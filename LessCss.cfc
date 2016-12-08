<cfcomponent output="false">

  <cffunction name="init" access="public" output="false">
    <cfscript>
      StructDelete(application, "lesscss", false);

      this.version = "1.1.7,1.1.8,1.4.5,2.0";
    </cfscript>
    <cfreturn this />
  </cffunction>

  <cffunction name="lessLinkTag" access="public" output="false" returntype="string" mixin="controller">
    <cfargument name="sources" type="string" required="false" default="" />
    <cfargument name="type" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.type#" />
    <cfargument name="media" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.media#" />
    <cfargument name="delim" type="string" required="false" default=","  />
    <cfargument name="bundle" type="string" required="false" default="" />
    <cfscript>
      if (Len(arguments.bundle))
      {
        if (application.wheels.showErrorInformation && !StructKeyExists(variables, "$includeMethodArguments"))
          $throw(type="Wheels", message="Plugin Missing", extendedInfo="You must include the asset bundler plugin to use the bundle argument.");

        // need to do this to make the method seem like a plugin method for asset bundler
        core.$lessLinkTag = variables.$lessLinkTag;

        if (ListFindNoCase("testing,production", application.wheels.environment)) {
          arguments = $includeMethodArguments($fileType="css", argumentCollection=arguments);
          return core.styleSheetLinkTag(argumentCollection = arguments);
        }
        else {
          arguments = $includeMethodArguments($fileType="less", argumentCollection=arguments);
          return $lessLinkTag(argumentCollection=arguments);
        }
      }

      if (ListFindNoCase("testing,production", application.wheels.environment) && StructKeyExists(application, "lesscss"))
      {
        arguments.sources = mapLessCssFiles(sources=arguments.sources);
        return styleSheetLinkTag(argumentCollection=arguments);
      }

      StructDelete(arguments, "bundle");
    </cfscript>
    <cfreturn $lessLinkTag(argumentCollection=arguments) />
  </cffunction>

  <cffunction name="$lessLinkTag" access="public" output="false" returntype="string" mixin="controller">
    <cfargument name="sources" type="string" required="false" default="" />
    <cfargument name="type" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.type#" />
    <cfargument name="media" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.media#" />
    <cfargument name="delim" type="string" required="false" default=","  />
    <cfscript>
      var loc = {};
      $args(name="styleSheetLinkTag", args=arguments, combine="sources/source", reserved="href,rel");
      arguments.rel = "stylesheet/less";
      loc.returnValue = "";
      arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);

      if (!StructKeyExists(request.wheels, "lessJsIncluded"))
      {
        // leaving out the development mode on 1.1.5 for now
        $writeLessScriptVariables();
        javaScriptIncludeTag(source="//cdnjs.cloudflare.com/ajax/libs/less.js/2.7.1/less.min.js", head=true);
        request.wheels.lessJsIncluded = true;
      }

      for (loc.item in arguments.sources)
      {
        if (ReFindNoCase("^https?:\/\/", loc.item))
        {
          arguments.href = arguments.sources[loc.i];
        }
        else
        {
          arguments.href = application.wheels.webPath & application.wheels.stylesheetPath & "/" & loc.item;
          if (!ListFindNoCase("less", ListLast(loc.item, ".")))
            arguments.href = arguments.href & ".less";
          arguments.href = $assetDomain(arguments.href) & $appendQueryString();
        }

        loc.returnValue = loc.returnValue & $tag(name="link", skip="sources,head,delim", close=true, attributes=arguments) & chr(10);
      }
    </cfscript>
    <cfreturn loc.returnValue />
  </cffunction>

  <cffunction name="mapLessCssFiles" access="public" output="false" returntype="string" mixin="application,controller">
    <cfargument name="sources" type="string" required="true" />
    <cfscript>
      var loc = {};

      arguments.sources = $listClean(arguments.sources);

      for (loc.item in ListToArray(arguments.sources))
        if (StructKeyExists(application.lesscss, loc.item))
          arguments.sources = ListSetAt(arguments.sources, ListFind(arguments.sources, loc.item), application.lesscss[loc.item]);
    </cfscript>
    <cfreturn arguments.sources />
  </cffunction>

  <cffunction name="generateLessCssFiles" access="public" output="false" returntype="void" mixin="application">
    <cfargument name="sources" type="string" required="false" default="" />
    <cfargument name="compress" type="boolean" required="false" default="true" />
    <cfargument name="extension" type="string" required="false" default=".less" />
    <cfargument name="rootPath" type="string" required="false" default="#application.wheels.webPath & application.wheels.stylesheetPath#/" />
    <cfscript>
      var loc = {};

      if (!StructKeyExists(application, "lesscss"))
        application.lesscss = {};

      if (StructKeyExists(arguments, "source"))
        arguments.sources = arguments.source;

      arguments.sources = $listClean(arguments.sources);

      if (!ListFindNoCase("production,testing", application.wheels.environment))
        return;

      loc.javaLoader = $createLessJavaLoader();
      loc.lessEngine = loc.javaLoader.create("com.inet.lib.less.Less").init();

      for (loc.item in ListToArray(arguments.sources))
      {
        loc.source = loc.item;

        if (!ListFindNoCase("less", ListLast(loc.source, ".")))
          loc.source &= ".less";

        loc.destination = REReplace(loc.source, "\.less$", ".css", "one");

        // make sure we have our extension
        if (Reverse(arguments.extension) neq Left(Reverse(loc.source), Len(arguments.extension)))
          loc.source &= arguments.extension;

        loc.sourceFile = CreateObject("java", "java.io.File").init(ExpandPath(arguments.rootPath & loc.source));
        loc.destinationFile = ExpandPath(arguments.rootPath & loc.destination);

        loc.output = loc.lessEngine.compile(loc.sourceFile, javacast("boolean", arguments.compress));

        fileWrite(loc.destinationFile, loc.output);

        // save where the compiled file is the in application scope
        application.lesscss[loc.source] = loc.destination;
      }
    </cfscript>
  </cffunction>

  <cffunction name="$createLessJavaLoader" access="public" output="false" returntype="any" mixin="application">
    <cfscript>
      var loc = {};

      if (!StructKeyExists(server, "javaloader") || !IsStruct(server.javaloader))
        server.javaloader = {};

      if (StructKeyExists(server.javaloader, "lesscss"))
        return server.javaloader.lesscss;

      loc.relativePluginPath = application.wheels.webPath & application.wheels.pluginPath & "/lesscss/";
      loc.classPath = Replace(Replace(loc.relativePluginPath, "/", ".", "all") & "javaloader", ".", "", "one");

      loc.paths = ArrayNew(1);
      loc.paths[1] = ExpandPath(loc.relativePluginPath & "lib/jlessc-1.4.jar");

      // set the javaLoader to the request in case we use it againx
      server.javaLoader.lesscss = $createObjectFromRoot(path=loc.classPath, fileName="JavaLoader", method="init", loadPaths=loc.paths, loadColdFusionClassPath=false);
    </cfscript>
    <cfreturn server.javaLoader.lesscss />
  </cffunction>

  <cffunction name="$writeLessScriptVariables" access="public" output="false" returntype="void" mixin="controller">
    <cfset var script = "" />
    <cfsavecontent variable="script"><cfoutput><script type="text/javascript">less = {}; less.env = 'development';</script></cfoutput></cfsavecontent>
    <cfhtmlhead text="#script#" />
  </cffunction>

</cfcomponent>
