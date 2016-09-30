# Devise 101



## Getting Started

### (1) Add The Devise Gem
+ Add the Devise gem to your project's `Gemfile` and then run `bundle install`:
`gem 'devise'`

### (2) Run Installer/Generator
+ Install Devise in your project by running the following command
`$ rails generate devise:install` or simply `$ rails g devise:install`

+ Devise will generate the following files:

  - `config/initializers/devise.rb` - This file is well documented with many different configuration options. You should read through it at some point.

  - `config/locales/devise.en.yml` - Stores various messages that Devise uses and can be customized to fit your needs.

  ###### Note: Once Devise has successfully been installed, a series of setup instructions will be displayed in your terminal (shown bellow). You'll want to read over the message and make sure after installation you've implemented all requirements.

```
===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================
```

### (3) Create a Devise Model
Next you'll need to create a Devise model in your application. It does *not* have to be named `User`, however it will represent the model used for your application’s users. The name you choose will also determine the name of Devise' helpers (example: `user_signed_in?`, `current_user`, `user_session`).

`$ rails g devise User`

+ Generating a Devise model will create the following files along with additional test files:

  - `app/models/user.rb` - Will be created unless that model already exists (appended to if previously created). There will be several modules included by default within the file and several others commented out. You may choose which ones to use within your project but make sure to update your migration file to reflect changes.

    ###### Note: For example, if you add the `confirmable` module in your model, you'll want to uncomment the *Confirmable* section in the migration file.

  - `db/migrate/<time_stamp>_devise_create_users.rb` - Contains attributes for several Devise modules included by default.

  - `devise_for :users` - This method call is added to the top of your `config/routes.rb` file and adds a number of additional routes to your project.

### (4) Migrate Your Database
* When ready content with your Devise model, migrate your database:
`$ rake db:migrate`

  ###### Note: Make sure to restart your application after making any changes to Devise's configuration options. Otherwise, you will run into strange errors, for example, users being unable to login and route helpers being undefined.

  ###### Note: You may also want to run `rake routes` to see a list of additional routes Devise has added to your project.

### (5) Congrats, setup complete!
At this point Devise should be fully functional within your project.



***
## Configuring/Customizing Views
While the following steps aren't necessary, they are helpful as you begin to customize Devise to conform to your project.


### Creating views
+ By default, Devise' views are loaded from its gemset code (not viewable in your application). While these views will help you get started, after some time you may want to begin customizing them to fit your specific project needs. First fun the following command:

  `$ rails g devise:views`

+ This generator will create a new `devise` directory inside of your `views` folder and will house all Devise related views (readily available for editing). `app/views/devise` will now contain the following directories:


__confirmations:__
+ Contains a lone `new.html.erb` view which gets rendered when a user requests for a confirmation email to be resent.

__mailer:__
+ Where you'll find Devise' email templates. They include `confirmation_instructions.html.erb`, `password_change.html.erb`, `reset_password_instructions.html.erb`, and  `unlock_instructions.html.erb` views.

__passwords:__
+ Contains a `new.html.erb` and `edit.html.erb` views which are forms to reset an email address, request new password, and to change a password.

__registrations:__
+ The `new.html.erb` view is rendered when a new user registers and the `edit.html.erb` contains a form to update their profile.

__sessions:__
+ Contains only a `new.html.erb` file, which functions as the login form for your application.

__shared:__
+ Contains only the partial `_links.html.erb`, which includes links that are displayed on each Devise’ view (example: "Sign in", "Forgot your password?", etc.)

__unlocks:__
+ Contains only a `new.html.erb` view with a form for requesting an unlock account link via email.

###### Note: If you would like to generate only a few sets of views, for example the `registerable` and the `confirmable` modules, simply pass the generator a list of specific modules to include adding the `-v` flag.

  `$ rails g devise:views -v registrations confirmations`


***
### Creating views (with scopes)
By default, Devise' models share the same views however this behavior can be changed to create different views based on their scope.

+ Lets say you have two Devise models, a User and Admin, and you'd like to generate different views for each model. You'll need to inside of your `config/initializers/devise.rb` file and *uncomment* the following line of code:

  `config.scoped_views = true`

+ Next simply pass in the name of the model (scope) to the generator and Devise will take care of the rest.

`$ rails g devise:views users`
`$ rails g devise:views admin`

+ This action will generate the same views as before with the `rails g devise:views` command except rather than creating `app/views/devise`, your views will be housed inside a newly created directory named after your scope. For example you'll have directories for `app/views/users/sessions`, `app/views/admin/registrations`, and so forth.

+ If for any reason a specific view is not found within a given scope, Devise will instead attempt to look for a default view for that module in the `app/views/devise/<module name>` directory.


***
### Configuring/Customizing Controllers
When you customize a Devise view, at some point you'll probably want to add additional attributes to your forms (example: adding a `first_name` and `last_name` field to the signup form). To do so you'll need to inform Devise of any additional parameters you wish to add in order for those attributes to be properly sanitized (whitelisted), thus enabling them to be permitted through *strong params*.

+ There are only three actions in Devise that would allow any set of parameters to be passed from a controller to the model and therefore would require sanitization. The name of their corresponding controllers & actions, plus their default permitted parameters (attributes) are as follows:

  `sign_in (Devise::SessionsController#create)` - Permits only the authentication keys (example: an email or username)

  `sign_up (Devise::RegistrationsController#create)` - Permits authentication keys plus password and password_confirmation

  `account_update (Devise::RegistrationsController#update)` - Permits authentication keys plus password, password_confirmation and current_password


+ There are two approaches when it comes to adding new attributes to your Devise forms.

### Option 1 (aka the lazy way™)

+ If you would like to permit additional parameters, you can do so by adding a `before_action` in your `ApplicationController`.

+ Next create a `#configure_permitted_parameters` method, include `devise_parameter_sanitizer.permit(:sign_up, keys: [])`, and add your new parameters to the `keys: [:your_attribute]` array.

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

end
```


#### Handling Nested Attributes
The example above is fine when adding a basic field(s) where the parameters are simple scalar types. However if you're adding *nested attributes* (example: you're using `accepts_nested_attributes_for` in your model), in this case you'll need to inform Devise about those nestings and types.

+ Optionally you may change Devise' defaults or provide custom behavior by passing a block. To permit simple scalar values for both a username and email, you could use the following technique:

```ruby
def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_in) do |user_params|
    user_params.permit(:username, :email)
  end
end
```

#### Handling Checkboxes
If you add checkboxes (example: to express various roles a user may choose during registration), the browser will submit those selected checkboxes as an array. Remember, an array is not one of *strong params* permitted scalars, so you'll need to configure Devise in the following way:

```ruby
def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    user_params.permit({ roles: [] }, :email, :password, :password_confirmation)
  end
end
```



### Option 2
If customization at the view level is not enough, you can create customized controller by following these steps:

#### 1. Generating new custom controller(s)
In order to generate custom controllers with Devise, you must provide a scope. If you do not specify a controller, it will be assumed you want to generate all 6 Devise controllers.  Run the following command to create a Devise controller(s):

`$ rails g devise:controllers users`

+ The command above would generate the following controllers and place them inside of `app/controllers/users` directory.

    `confirmations controller`
    `passwords controller`
    `registrations controller`
    `sessions controller`
    `unlocks controller`
    `omniauth_callbacks controller`

+ To target a specific Devise controller to create, pass in the `-c` flag followed by the controller's name you'd like to create.

  `rails g devise:controllers users -c=registrations`

+ The command above would generate a Devise `registrations` controller and place it inside of your `app/controllers/users` directory.

#### 2. Overriding default controllers
In your `config/routes.rb` file, you'll need to tell the router to use the newly created controller(s) as opposed to the corresponding default Devise controller you're overriding.

```ruby
    Rails.application.routes.draw do
      devise_for :users, controllers: {
        sessions: 'users/sessions'
      }
    end
```

+ Adding the `:controllers` option allows us to override what controller devise uses for certain modules, and in this example we're overriding the default `sessions` controller with our own located in `users/sessions_controller.rb`.




#### 3. Creating or moving your views
If you've previously generated views (`rails g devise:views`), they'll need to be moved in order for your new controller(s) to properly use them.

+ For example if you've generated a new Devise `sessions` controller with a `users` scope, Devise won't use the default views located in `devise/sessions/`, but rather look for corresponding views in the `users/sessions/` directory. Therefore you'll need to move or copy all related views to their new directories.

+ If on the other hand you have not yet created your Devise views, simply provide the scope you'd like the views to be placed in.

+ Running `rails g devise:views users` would automatically place your new views inside the `app/views/users` directory, making it ready to use by your new controller(s).


#### 4. Setting your new controller actions
+ Finally, change or extend the desired actions of your newly created controllers.
+ You can completely override a controller action:

```ruby
class Users::SessionsController < Devise::SessionsController
  def create
    # custom sign-in code
  end
end
```

+ Optionally you can simply add new behavior to it (useful for triggering background jobs or logging events during certain actions.):

```ruby
class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end
end
```
