# Customizing SMC-Connect

Make sure you've [installed](https://github.com/smcgov/SMC-Connect/blob/master/INSTALL.md) the app first.

## Environment variables
Inside the `config` folder, you will find a file named `application.yml`.
Read through the documentation to learn how you can customize the app to suit
your needs, including pointing the app to your own instance of Ohana API.

If you're planning on deploying the app to Heroku, you can set all the required environment variables in production by running the following command:

```
$ script/setup_heroku -a your_app_name -o your_api_endpoint
```
`your_api_endpoint` is the URL to your instance of Ohana API, such as `https://ohana-api-demo.herokuapp.com/api`. `your_app_name` is your Heroku app's name. Read the [script](https://github.com/smcgov/SMC-Connect/blob/master/script/setup_heroku) for more details about what it will install.

The script only sets required environment variables. To set optional environment variables on Heroku, such as `GOOGLE_ANALYTICS_ID`, you'll need to set them manually. Read through `application.example.yml` to learn about all the optional variables you can set, and read the Heroku documentation to learn how to [set Heroku configuration variables](https://devcenter.heroku.com/articles/config-vars).

By default, the script assumes you will be using a `*.herokuapp.com` domain name. If you will be using a custom domain name, you will need to set the `CANONICAL_URL` variable manually. Read `application.example.yml` for more details.

## Website settings
Inside the `config` folder, you will find a file called `settings.yml`.
In that file, there are many settings you can, and should, customize.
Read through the documentation to learn how you can customize the app to suit
your needs.

## Localization
Inside the `config/locales` folder, you will find a file called `en.yml`.
In that file, you can customize much of the user-facing text on the website.
Most of the text should be ready to go, but there is one specific setting
you should customize: the [location](https://github.com/smcgov/SMC-Connect/blob/master/config/locales/en.yml#L28) value under `branding`.

## Pagination
The pagination of search results is handled by the [Kaminari](https://github.com/amatsuda/kaminari) gem.
To configure the functionality, make changes in [kaminari_config.rb](https://github.com/smcgov/SMC-Connect/blob/master/config/initializers/kaminari_config.rb).
To change the informational text about the search results, visit the [page_entries_info](https://github.com/smcgov/SMC-Connect/blob/master/config/locales/en.yml#L46-55) section in `en.yml`.
To change the labels for the navigation buttons, visit the [pagination](https://github.com/smcgov/SMC-Connect/blob/master/config/locales/en.yml#L98-103) section in `en.yml`. To change the markup, make changes to the partials in [app/views/kaminari](https://github.com/smcgov/SMC-Connect/tree/master/app/views/kaminari).

To test the pagination feature, you might find it handy to force a particular
number of results per page by adding the `per_page` parameter to the end of the
URL. For example: [https://ohana-web-search-demo.herokuapp.com/locations?utf8=%E2%9C%93&keyword=&location=&per_page=5](https://ohana-web-search-demo.herokuapp.com/locations?utf8=%E2%9C%93&keyword=&location=&per_page=5)

## Custom graphics
The root `graphics` folder contains source template files for images in the application. Using these templates you can edit and re-generate the major graphics of the application. These are provided in Adobe Illustrator and SVG formats.

- **Application logo**.
The `app_logo` file can be used to adjust the application logo in the upper-left of the site. Make changes and export and overwrite the file in `/app/assets/images/app_logo.png`.

- **Map marker graphics**.
The `map_icons_template` file can be used to adjust the map marker appearance by making changes and exporting and overwriting the files in `/app/assets/images/markers`. The Google map appears on the search results and location details pages.

- **Touch icons**.
The `touch_icons_template` file can be used to change the touch icon that shows up in mobile and tablet devices when the site is saved to the home screen. Adjust the appearance by making changes and exporting and overwriting the files in `/app/assets/images/touch_icons`.

## Adding JavaScript code
Ohana Web Search doesn't use the default `application.js` manifest file for loading JavaScript files that may be
found in a typical Rails app. Instead, it uses a modular JavaScript pattern through the [requirejs-rails gem](https://github.com/jwhitley/requirejs-rails). More information about this setup can be found in the modified
[application.js][applicationjs] file and the [RequireJS configuration][requirejsconfig] file.

[applicationjs]: https://github.com/smcgov/SMC-Connect/blob/master/app/assets/javascripts/application.js
[requirejsconfig]: https://github.com/smcgov/SMC-Connect/blob/master/config/requirejs.yml

## Allow search engines to index your site
Search engines are blocked by default so that they don't index your site until it's ready.
Once your site is serving your own data from your own instance of Ohana API, and once you're satisfied with the content on your site, then you can invite search engines to index your site by commenting out lines 4 and 5 in [public/robots.txt](https://github.com/smcgov/SMC-Connect/blob/master/public/robots.txt#L4-5), like so:
```
# User-agent: *
# Disallow: /
```

## Caching
See this Wiki article on [improving performance with caching][caching].

[caching]: https://github.com/smcgov/SMC-Connect/wiki/Improving-performance-with-caching
