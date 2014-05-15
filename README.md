


# Testing

* [Jasmine](http://jasmine.github.io/)
* [Karma](http://karma-runner.github.io/0.12/index.html)
* [CasperJS](http://casperjs.org/)
* [PhantomCSS](https://github.com/Huddle/PhantomCSS)
* [Jest](http://facebook.github.io/jest/)

Use [jasmine-npm](https://github.com/pivotal/jasmine-npm) once it's available.
[Minijasminenode](https://github.com/juliemr/minijasminenode/issues/9) will eventually be deprecated.


# Resources

* [CSS 3D Matrix Transformations](http://www.eleqtriq.com/2010/05/css-3d-matrix-transformations/)
* [Testing and Debugging Angular](http://www.yearofmoo.com/2013/09/advanced-testing-and-debugging-in-angularjs.html)

# Notes

Parse 1.2.18 and earlier has a bug with Facebook login. Facebook returns valid iso8601 dates for
the token expires field but Parse._parseDate fails to parse it correctly and break login. Fucking great.
A temp patch has been added to parse-1.2.18-fixed-parsedate.js. If the regex fails, the date is parsed
using the browser's native date parser. This will only work in ECMAScript 5 browser.

A permanent solution is to fix the regex.






