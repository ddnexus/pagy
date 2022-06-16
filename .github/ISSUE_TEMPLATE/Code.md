---
name: Code
about: Use this template for code issues
title: ''
labels: ''
assignees: ''

---
<!--

Code Issues are reserved for real, reproducible pagy-code issues. If you are not sure about it, please use the "Pagy Chat Support" button issue.

By following the steps below you will either solve your problem or ensure that it's a real reproducible issue to fix.

WARNING: CODE ISSUES NOT FOLLOWING THIS TEMPLATE MAY BE DELETED WITHOUT NOTICE 

-->

# Code Issue
- [ ] I researched through the [documentation](https://ddnexus.github.io/pagy/), the [pagy issues](https://github.com/ddnexus/pagy/issues) and a known Search Engine, and there is no reference|report|post|video that solves this problem
- [ ] I did install|upgraded to the latest version of pagy (or the latest `3.*` for pagy legacy)
- [ ] I am providing at least one of the following working and self-contained code support that can reproduce this issue:
   <!-- Check all that apply [x] -->
   - [ ] Simple step by step list that would work in IRB with the [Pagy::Console](https://ddnexus.github.io/pagy/api/console)
   - [ ] Plain ruby file that can run as `ruby my-problem.rb`
   - [ ] Edited copy of the single file [pagy_standalone_app.ru](https://github.com/ddnexus/pagy/blob/master/apps/pagy_standalone_app.ru)
   - [ ] Edited copy of the single file [pagy_bare_rails.rb](https://github.com/ddnexus/pagy/blob/master/apps/pagy_bare_rails.rb)
   - [ ] Link of my own branch forked from pagy, which contains an added test file  
   - [ ] Link of my own branch forked of [any of the rails apps listed here.](https://github.com/stars/benkoshy/lists/rails-demo-apps-for-pagy)
   - [ ] Link of a standalone `docker image` downloadable from a docker repository (e.g. dockerhub.com)
   - [ ] `docker-compose` file that can be run with `docker-compose up` (and doesn't need to be built because it uses only docker images and no local context)

<!-- IMPORTANT: repositories of your own apps are not an acceptable support unless they satisfy one of the points above. -->


### Ruby|Rails|Sinatra|... Versions

...

### Description

...

### Steps to reproduce the issue using the provided support

...

Thank you!
