# Less CSS v0.1

The Less CSS plugin gives you the ability to easily incorporate [Less CSS][] into your wheels application. In design and development environments, the plugin includes the less css javascript to compile the less css client side for easy development. When in testing and production environments, the plugin uses the [asual less css java engine][] to compile your less css on application reload to keep your site or application snappy and light on http requests.

## Dependencies

This plugin uses the [asual less css java engine][] and the [Less CSS][] javascript framework.

## Usage

### Application Configuration

Call the included `generateLessCssFiles()` method from the `events/onapplicationstart.cfm` to configure what less files to compile when moving to the testing or production environments.

Call `lessLinkTag()` in your application's layouts to render everything necessary for less CSS to work in all wheels environment settings.

#### Methods

<table>
	<tbody>
		<tr>
			<td><strong>generateLessCssFiles</strong></td>
			<td>Application start method to compile your less css files when moving to testing or production environments.</td>
		</tr>
		<tr>
			<td><strong>lessLinkTag</strong></td>
			<td>Handy helper method to link up less CSS files in your views.</td>
		</tr>
	</tbody>
</table>

#### Method Specifications

##### generateLessCssFiles

<table>
	<thead>
		<tr>
			<td>Argument</td>
			<td>Type</td>
			<td>Required</td>
			<td>Default</td>
			<td>Description</td>
		</tr>
	</thead>
	<tbody>
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
			<td>Whether to compress the combined less CSS files with the asset bundler. Requires you have the asset bundler plugin installed.</td>
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
	</tbody>
</table>

##### lessLinkTag

<table>
	<thead>
		<tr>
			<td>Argument</td>
			<td>Type</td>
			<td>Required</td>
			<td>Default</td>
			<td>Description</td>
		</tr>
	</thead>
	<tbody>
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
			<td>When asset bundler is installed, you can specify a bundle to output. Requires you have the asset bundler plugin installed.</td>
		</tr>
	</tbody>
</table>


Uninstallation
--------------

To uninstall this plugin, simply delete the
`/plugins/lesscss-0.1.zip` file.

Credits
-------

This plugin was created by [James Gibson][] with support from
[Arthrex][].

  [Less CSS]: http://lesscss.org/
  [Asual less css java engine]: https://github.com/asual/lesscss-engine
  [Asset Bundler]: https://github.com/liferealized/assetbundler
  [James Gibson]: http://iamjamesgibson.com/
  [Arthrex]: http://www.arthrex.com/
