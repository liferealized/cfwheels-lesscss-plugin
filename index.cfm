<h1>Less CSS v0.1</h1>

<p>The Less CSS plugin gives you the ability to easily incorporate <a href="http://lesscss.org/">Less CSS</a> into your wheels application. In design and development environments, the plugin includes the less css javascript to compile the less css client side for easy development. When in testing and production environments, the plugin uses the <a href="https://github.com/asual/lesscss-engine">asual less css java engine</a> to compile your less css on application reload to keep your site or application snappy and light on http requests.</p>

<h2>Dependencies</h2>

<p>This plugin uses the <a href="https://github.com/asual/lesscss-engine">asual less css java engine</a> and the <a href="http://lesscss.org/">Less CSS</a> javascript framework.</p>

<h2>Usage</h2>

<h3>Application Configuration</h3>

<p>Call the included <code>generateLessCssFiles()</code> method from the <code>events/onapplicationstart.cfm</code> to configure what less files to compile when moving to the testing or production environments.</p>

<p>Call <code>lessLinkTag()</code> in your application's layouts to render everything necessary for less CSS to work in all wheels environment settings.</p>

<h4>Methods</h4>

<table>
<tbody><tr>
<td><strong>generateLessCssFiles</strong></td>
            <td>Application start method to compile your less css files when moving to testing or production environments.</td>
        </tr>
<tr>
<td><strong>lessLinkTag</strong></td>
            <td>Handy helper method to link up less CSS files in your views.</td>
        </tr>
</tbody></table><h4>Method Specifications</h4>

<h5>generateLessCssFiles</h5>

<table>
<tbody><tr>
<td>Argument</td>
            <td>Type</td>
            <td>Required</td>
            <td>Default</td>
            <td>Description</td>
        </tr>
<tr>
<td>source/sources</td>
            <td>string</td>
            <td>Yes</td>
            <td></td>
            <td>A list of less CSS files to compile when necessary.</td>
        </tr>
<tr>
<td>compress</td>
            <td>boolean</td>
            <td>No</td>
            <td>false</td>
            <td>Whether to compress the combined less CSS files with the [Asset Bundler][]. Requires you have the [Asset Bundler][] plugin installed.</td>
        </tr>
<tr>
<td>extension</td>
            <td>string</td>
            <td>No</td>
            <td>.less</td>
            <td>The extension of your less CSS files.</td>
        </tr>
<tr>
<td>rootPath</td>
            <td>string</td>
            <td>No</td>
            <td>stylesheets</td>
            <td>The path where your less files reside.</td>
        </tr>
</tbody></table><h5>lessLinkTag</h5>

<table>
<tbody><tr>
<td>Argument</td>
            <td>Type</td>
            <td>Required</td>
            <td>Default</td>
            <td>Description</td>
        </tr>
<tr>
<td>source/sources</td>
            <td>string</td>
            <td>Yes</td>
            <td></td>
            <td>The sources to make `&lt;link /&gt;` tags for.</td>
        </tr>
<tr>
<td>type</td>
            <td>string</td>
            <td>No</td>
            <td>text/css</td>
            <td>The type attribute of the link tag.</td>
        </tr>
<tr>
<td>media</td>
            <td>string</td>
            <td>No</td>
            <td>screen, projection</td>
            <td>What media the stylesheet should be displayed for.</td>
        </tr>
<tr>
<td>delim</td>
            <td>string</td>
            <td>No</td>
            <td>,</td>
            <td>Delimitered used in the sources argument.</td>
        </tr>
<tr>
<td>bundle</td>
            <td>string</td>
            <td>No</td>
            <td></td>
            <td>When [Asset Bundler][] is installed, you can specify a bundle to output. Requires you have the [Asset Bundler][] plugin installed.</td>
        </tr>
</tbody></table><h2>Uninstallation</h2>

<p>To uninstall this plugin, simply delete the
<code>/plugins/lesscss-0.1.zip</code> file.</p>

<h2>Credits</h2>

<p>This plugin was created by <a href="http://iamjamesgibson.com/">James Gibson</a> with support from
<a href="http://www.arthrex.com/">Arthrex</a>.</p>