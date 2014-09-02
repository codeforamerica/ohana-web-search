# Customizing Ohana Web Search

## Environment variables
Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml` in the same directory.
Read through the documentation to learn how you can customize the app to suit
your needs.

If you're planning on deploying the app to Heroku, you can set all the required environment variables in production by running the following command:

```
$ script/setup_heroku -a your_app_name -o your_api_endpoint
```
`your_api_endpoint` is the URL to your instance of Ohana API, such as `http://ohana-api-demo.herokuapp.com/api`. `your_app_name` is your Heroku app's name. Read the [script](https://github.com/codeforamerica/ohana-web-search/blob/master/script/setup_heroku) for more details about what it will install.

The script only sets required environment variables. To set optional environment variables on Heroku, such as `GOOGLE_ANALYTICS_ID`, you'll need to set them manually. Read through `application.example.yml` to learn about all the optional variables you can set, and read the Heroku documentation to learn how to [set Heroku configuration variables](https://devcenter.heroku.com/articles/config-vars).

By default, the script assumes you will be using a `*.herokuapp.com` domain name. If you will be using a custom domain name, you will need to set the `CANONICAL_URL` and `DOMAIN_NAME` variables manually. Read `application.example.yml` for more details about those variables.

## Website settings
Inside the `config` folder, you will find a file called `settings.yml`.
In that file, there are many settings you can, and should, customize.
Read through the documentation to learn how you can customize the app to suit
your needs.

## Localization
Inside the `config/locales` folder, you will find a file called `en.yml`.
In that file, you can customize much of the user-facing text on the website.
Most of the text should be ready to go, but there is one specific setting
you should customize: the [location](https://github.com/codeforamerica/ohana-web-search/blob/master/config/locales/en.yml#L28) value under `branding`.

## Pagination
The pagination of search results is handled by the [Kaminari](https://github.com/amatsuda/kaminari) gem.
To configure the functionality, make changes in [kaminari_config.rb](https://github.com/codeforamerica/ohana-web-search/blob/master/config/initializers/kaminari_config.rb).
To change the informational text about the search results, visit the [page_entries_info](https://github.com/codeforamerica/ohana-web-search/blob/master/config/locales/en.yml#L46-55) section in `en.yml`.
To change the labels for the navigation buttons, visit the [pagination](https://github.com/codeforamerica/ohana-web-search/blob/master/config/locales/en.yml#L98-103) section in `en.yml`. To change the markup, make changes to the partials in [app/views/kaminari](https://github.com/codeforamerica/ohana-web-search/tree/master/app/views/kaminari).

To test the pagination feature, you might find it handy to force a particular
number of results per page by adding the `per_page` parameter to the end of the
URL. For example: [http://ohana-web-search-demo.herokuapp.com/locations?utf8=%E2%9C%93&keyword=&location=&per_page=5](http://ohana-web-search-demo.herokuapp.com/locations?utf8=%E2%9C%93&keyword=&location=&per_page=5)

## Map marker graphics
The root `graphics` folder contains source files for images in the application. In this directory, you can find an Adobe Illustrator source file for the Google map marker graphics. With this file you can adjust the map marker appearance by making changes and exporting and overwriting the files in `/app/assets/images/markers`. The Google map appears on the search results and location details pages.

## Adding JavaScript code
Ohana Web Search doesn't use the default `application.js` manifest file for loading JavaScript files that may be
found in a typical Rails app. Instead, it uses a modular JavaScript pattern through the [requirejs-rails gem](https://github.com/jwhitley/requirejs-rails). More information about this setup can be found in the modified
[application.js][applicationjs] file and the [RequireJS configuration][requirejsconfig] file.

[applicationjs]: https://github.com/codeforamerica/ohana-web-search/blob/master/app/assets/javascripts/application.js
[requirejsconfig]: https://github.com/codeforamerica/ohana-web-search/blob/master/config/requirejs.yml

## Allow search engines to index your site
Search engines are blocked by default so that they don't index your site until it's ready.
Once your site is serving your own data from your own instance of Ohana API, and once you're satisfied with the content on your site, then you can invite search engines to index your site by commenting out lines 4 and 5 in [public/robots.txt](https://github.com/codeforamerica/ohana-web-search/blob/master/public/robots.txt#L4-5), like so:
```
# User-agent: *
# Disallow: /
```

## Caching
To improve the performance of the app, you can configure two types of caching: one is caching the API requests via `Faraday::HttpCache` in [config/initializers/ohanapi.rb](https://github.com/codeforamerica/ohana-web-search/blob/master/config/initializers/ohanapi.rb), and the other is caching the entire results page and/or location details page.

API request caching is turned on by default, and will prevent the app from making the same API request for a [period of time specified by the API](https://github.com/codeforamerica/ohana-api/blob/master/config/application.example.yml#L82-89). By default, that is set to 5 minutes. That means that if a location's info has changed on the API side, if Ohana Web Search had already requested that same location, the latest data changes won't appear in Ohana Web Search until 5 minutes have passed since the first request was made.

As for page caching, it is disabled by default. To turn it on, you will need to set the `ENABLE_CACHING` environment variable on your production server to `true`. If you're using Heroku, you can set it like this:
```
$ heroku config:set ENABLE_CACHING=true -a your_heroku_app_name
```

When page caching is enabled, it will store the page in Memcached via the [MemCachier add-on on Heroku](https://addons.heroku.com/memcachier) (by default) so that the next time any browser requests that same page, it will be served from cache instead of the server. In addition to the app storing the page in Memcached, most modern browsers will also store the page in their cache, and will check the `Last Modified` date to see if a newer version exists.

Because the `Last Modified` date is based on the `updated_at` field returned by the API, any changes you make to the HTML will not appear on the website as long as the `updated_at` field hasn't changed, and as long as the browser is still fetching the page from its cache. In order to invalidate the cache for your site visitors, you'll need to flush the MemCachier cache, and update the `updated_at` field for all of the locations in the API.

To flush the MemCachier cache, follow these steps:

1. Log in to your Heroku account
2. Click on your app
3. In the Add-ons section, click on MemCachier
4. Click the "Flush" button

To update the `updated_at` field, follow these steps:

1. Run the Rails console for your instance of the Ohana API (not Ohana Web Search) on Heroku:

   ```
   $ heroku run rails c -a your_api_app_name
   ```

2. Update all locations:

   ```
   > Location.find_each(&:touch)
   ```

3. Quit the console:

   ```
   > quit
   ```
