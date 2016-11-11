## Action Cable Tester

Basted on "Chatty", a simple ActionCable demonstrator described in
[an article on the Heroku blog](https://blog.heroku.com/archives/2016/5/9/real_time_rails_implementing_websockets_in_rails_5_with_action_cable)
and available in a [github repo](https://github.com/SophieDeBenedetto/rails-5-action-cable-meetup). (the github repo version fixes some bugs
in the original blog code).

It is also worth looking at the examples in the [ActionCable repo](https://github.com/rails/rails/blob/master/actioncable/README.md)
and in the [Rails Guide](http://edgeguides.rubyonrails.org/action_cable_overview.html). 

This app is designed to mimic some basic behaviors of the Liveoak app. It requires SSL and runs the same version
of Ruby and Rails as Liveoak, and uses the same Puma config. But it omits as many support libraries as possible
that might affect the app's treatment by a firewall, such as rac-cors and rack-timeout. 

The message system is DB-backed, but there is no auth. Users "sign up" by providing a name.



### Running Locally

You'll need:

* Ruby 2.3.1
* Postgres
* Redis

Then, once you clone down this repo:

* `bundle install`
* `rake db:create; rake db:migrate`

And you're all set.

Start the server with

    foreman start

and the Procfile will take care of the rest. 

### Repo Management

The repo has a develop branch for fiddling around, and a master for deploying, just in case multiple people want to tinker with it.
There is no staging server since it's just a prototype, so the master runs on heroku as if it were a production server. Deploy with:

     git push heroku master:master
    
#### Browser Support

Chrome, Firefox, Opera, Brave (prob others) are fully supported.

##### Safari

Nothing websocket-related will work locally on Safari because Safari blocks websocket interactions with self-signed certificates.
The console will have the error:

    WebSocket network error: OSStatus Error -9807: Invalid certificate chain 

##### Edge

##### IE

### Cases and Issues

#### 1745 Web Sockets don't use authentication

Relates to BSA 3959-002. Auth in ActionCable is now explicit. 
