# Running your ruby on rails application on Docker -
* Use the Dockerfile commited as the base image for your application's docker image.
* If you are using anything other than unicorn to power your application, then make the necessary changes to the Procfile.
* Change the ruby version, gem, bundler version, etc by providing the versions as env.
