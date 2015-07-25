# Customizing Ohana Web Search

Make sure you've [installed](https://github.com/codeforamerica/ohana-web-search/blob/master/INSTALL.md) the app first.

## Prepare your repository

Assuming you have cloned your initial repository from `codeforamerica/ohana-web-search`, rename the default [remote][remote] from `origin` to `codeforamerica`. The `codeforamerica` remote can be used to synchronize your local copy with upstream changes using `git merge codeforamerica/master` or `git rebase codeforamerica/master`.

    git remote rename origin codeforamerica

[Create a new repository][repo] where you will keep your customized version of `ohana-web-search`. This repository can be called anything you like, e.g. `mycity-ohana-web-search`. Make sure you do not add a `.gitignore`, `README`, or `LICENSE` file to the new repository during this step since you will be pushing the contents of the cloned `codeforamerica` repository there shortly.

Add your newly created repository as the `origin` remote by following the on-screen instructions. The command will look something like this:

    git remote add origin git@gitub.com:MYORG/MY-OHANA-WEB-REPO.git

You can now push your clone of `ohana-web-search` to `origin`:

    git push origin master

[remote]: https://help.github.com/categories/managing-remotes/
[repo]: https://help.github.com/articles/create-a-repo/

## Environment variables
Inside the `config` folder, you will find a file named `application.yml`.
Read through the documentation to learn how you can customize the app to suit
your needs, including pointing the app to your own instance of Ohana API.

If you're planning on deploying the app to Heroku, you can set all the required environment variables in production by running the following command:

```
$ script/setup_heroku -a your_app_name -o your_api_endpoint
```
`your_api_endpoint` is the URL to your instance of Ohana API, such as `https://ohana-api-demo.herokuapp.com/api`. `your_app_name` is your Heroku app's name. Read the [script](https://github.com/codeforamerica/ohana-web-search/blob/master/script/setup_heroku) for more details about what it will install.

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

## Language Translation Services
The application uses Google Translate for free language translation of the site. The Google Website Translator Gadget appears in the footer of the site and provides free translation of the site into dozens of languages. By default, six major language translation links are provided (in their native script) on the upper-right of the homepage. A number of aspects related to translation can be customized:

- **Homepage language links**. The language translation links on the homepage can be added, removed, and edited in `config/settings.yml`.

- **Support for non-English keyword searches**. If you want your users to be able to enter a keyword search in a language other than English, do the following:
  1. Uncomment the Google Translate related lines in `app/controllers/locations_controller.rb`.
  2. Add a `GOOGLE_TRANSLATE_API_KEY` in `config/application.yml`. Follow the directions in that file for obtaining an API key from Google. **NOTE: GOOGLE CHARGES FOR THIS FEATURE.**

- **Change the gadget layout**. If you want to change the Google Website Translator Gadget's layout, two of the layouts provided by Google are supported: InlineLayout.VERTICAL and InlineLayout.HORIZONTAL. One or the other
can be set in `assets/javascripts/application.js`.

## Pagination
The pagination of search results is handled by the [Kaminari](https://github.com/amatsuda/kaminari) gem.
To configure the functionality, make changes in [kaminari_config.rb](https://github.com/codeforamerica/ohana-web-search/blob/master/config/initializers/kaminari_config.rb).
To change the informational text about the search results, visit the [page_entries_info](https://github.com/codeforamerica/ohana-web-search/blob/master/config/locales/en.yml#L46-55) section in `en.yml`.
To change the labels for the navigation buttons, visit the [pagination](https://github.com/codeforamerica/ohana-web-search/blob/master/config/locales/en.yml#L98-103) section in `en.yml`. To change the markup, make changes to the partials in [app/views/kaminari](https://github.com/codeforamerica/ohana-web-search/tree/master/app/views/kaminari).

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
See our Wiki article on [improving performance with caching][caching].

[caching]: https://github.com/codeforamerica/ohana-web-search/wiki/Improving-performance-with-caching
