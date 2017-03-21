

## Prerequisites
* variables
* methods


## A Simple Error

Many beginners to programming make the mistake of being afraid of errors. In fact, error messages are our friends! Without them, our code would not work and we wouldn't know why.

Experienced programmers encounter errors all the time. They then read the error message to figure out what's wrong with their code. Let's try some examples.

Make a file called `example.rb`. In it, put the following code:

```ruby
puts message
```

Now run the file on the command line with: `ruby example.rb`. Error! You should see the following:

```
example.rb:1:in `<main>': undefined local variable or method `message' for main:Object (NameError)
```

The error message is giving us a lot more information than that. Let's break some of it down.

* The file where the error took place was called `example.rb`
* The error happened on line 1 in that file
* The message itself was: `undefined local variable or method 'message' for main:Object`
* The type of error was `NameError`

That is a lot of information! Using it, we can very quickly track down exactly where the issue took place, as well as what the problem was.

In this case, we haven't defined `message` before using it. Ruby is therefore doing what we call `throwing` or `raising` an error - in this case, a `NameError`. That means that there is an issue with one of the 'names' we used. The Ruby interpreter doesn't know if we are trying to call a method called `message` or use a variable called `message`. In short, it doesn't understand the name "message".

There are [many types of errors in Ruby](https://ruby-doc.org/core-2.2.0/Exception.html), and there will be different ones in Rails. You will likely run into the same few errors over and over again in your development career. We will only explore a few in this assignment.

Great! So how do we fix it? In general, maybe we mistyped the name of the variable or method. Maybe we think something is defined and it isn't. What we have to do is *figure out if `message` is defined somewhere.* In our code, clearly it isn't. So let's fix it:

```ruby
message = 'Hello world!'
puts message
```

Running this again, we see:

```
Hello world!
```

It's important to remember that code runs in order. For example, the following code raises exactly the same error because `message` is not available to us on the first line:

```ruby
puts message
message = 'Hello world!'

# other code here
```

In the above example, we would be able to ignore every line of code below line 1. If the error happened on line 1, the rest of the code never got to run!


## Stack Traces

Let's make our existing example a little more complex in order to see slightly different error output.

```ruby
def output
  puts message
end

def call_output
  output
end

call_output
```

This time we're calling the method `call_output`, which in turn calls a method called `output`, which does our `puts` statement as normal. Running this, we should expect to get a similar error:

```
example.rb:2:in `output': undefined local variable or method `message' for main:Object (NameError)
	from example.rb:6:in `call_output'
	from example.rb:9:in `<main>'
```

This looks *almost* exactly the same, but there are a couple of extra lines here.

```
from example.rb:6:in `call_output'
from example.rb:9:in `<main>'
```

These lines, in combination with the first, are what we call a `stack trace`. The top of the 'stack' always contains the source of the actual error. This is often enough to solve the problem. The rest of the stack, from top to bottom, indicates the methods that have been called that led to the error. Let's work bottom to top to explore how a stack trace works.

>Stack traces
>Normally you'll read top to bottom, but we want to understand what's going on first!

```
from example.rb:9:in `<main>'
```

On line 9, we called the `call_output` method. Notice how the stack trace said `in '<main>'`. In Ruby, `<main>` is the top level of your program. It's where you are if you're not in a method (or class). We can see that our line of code is not in a method, so this checks out.

To move toward the next step of the stack trace, we have to understand what our line of code is doing. The line `call_output` is calling the method of that name. So this brings us to the second line (from the bottom) of the stack trace:

```
from example.rb:6:in `call_output'
```

On line 6, we are in the method `call_output`. Looking at `example.rb`, our code is simply calling the method `output`. So let's move on to that, and the final (top) line of our stack trace:

```
example.rb:2:in `output': undefined local variable or method `message' for main:Object (NameError)
```

On line 2, we're inside the method `output`. Here is where our actually error occurred. We know what happens here: we're using a 'name' that is not defined yet (or anywhere).

In the real world, you'll read your stack trace the other way around. Let's try a proper example!

## Finding the issue

Create a file called example2.rb and add the following code:

```ruby
def add_5(num)
  return num + 5
end

def get_time
  new_time = add_5('3')
  return "The time is #{new_time}"
end

puts get_time
```

Run it to get:

```
example2.rb:2:in `+': no implicit conversion of Fixnum into String (TypeError)
	from example2.rb:2:in `add_5'
	from example2.rb:6:in `get_time'
	from example2.rb:10:in `<main>'
```

We get an error. But remember, error messages are here to help us! Let's start at the top this time (as you always will in the real world).

```
example2.rb:2:in `+': no implicit conversion of Fixnum into String (TypeError)
```

It says that the error takes place in `example2.rb` (good, otherwise we're in the wrong file!) on line 2. Next, it says something about `+`. So we know it has to do with addition. The message is `no implicit conversion of Fixnum into String`. They are saying something about conversion between two types: `Fixnum` and `String`. It's okay if you don't understand more than that. Lastly, given that we are dealing with types, the error is a `TypeError`.

Looking at the line of code - `return num + 5` - it's not clear what is wrong! This looks pretty normal. We appear to be returning the addition of `5` with another number. We can't stop here; we have to look further down in our stack trace:

```
	from example2.rb:2:in `add_5'
```

This is the same line we just dealt with. It's telling us that the issue took place in the `add_5` method. Good to know! Let's move on to the next one - there isn't much new information here.

```
  from example2.rb:6:in `get_time'
```

It's pointing us to line 6. Our code there is:

```ruby
new_time = add_5('3')
```

What is wrong with this line? Maybe nothing - it's possible we might have to keep looking down the stack trace. But before we can move on, we need to see this line in context. It's setting a variable, and it's setting it to the result of `add_5('3')`. And we know that the issue took place inside of the method `add_5`.

Paying attention to the details, it looks like we are passing the string `3` to `add_5`. Now let's look at `add_5`. If `num` is a string - which it is if we pass `3` to it - will `num + 5` work? Substitute `'3'` for `num` and try it out in irb:

```
irb(main):001:0> '3' + 5
TypeError: no implicit conversion of Fixnum into String
	...etc.
```

We got an error, and, in fact, the same error message as before. Given that `'3' + 5` doesn't work, this must be our problem.

How do we fix it? The problem here is that our method `add_5` is expecting a number to be passed into it. It even calls this parameter 'num'. Let's change the `get_time` method so that we are passing `add_5` a number:

```ruby
def get_time
  new_time = add_5(3)
  return "The time is #{new_time}"
end
```

Delete the quotes around the `3` and we're done! Run it again to check that it is no longer erroring.

Notice that there was another line of the stack trace, but we didn't look at it. This is very common. Stack traces in the real world are very long, and we only need to read the parts that matter to us - right up until we figure out the problem.

An error message (with a stack trace) in Rails might look something like this:


```
ActionView::Template::Error (undefined local variable or method `team' for #<#<Class:0x007f8b0094d4e0>:0x007f8b0094c310>
Did you mean?  @team):
    1:
    2: <h1><%= "The #{@team.city} #{@team.name}" %></h1>
    3:
    4: <h2>League: <%= team.league.name %></h2>
    5:
    6: List players

app/views/teams/show.html.erb:4:in `_app_views_teams_show_html_erb__2449760013641390235_70117493468860'
  Rendering /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/template_error.html.erb within rescues/layout
  Rendering /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/_source.html.erb
  Rendered /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/_source.html.erb (3.9ms)
  Rendering /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb
  Rendered /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb (2.7ms)
  Rendering /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb
  Rendered /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb (1.0ms)
  Rendered /Users/daniel/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/actionpack-5.0.2/lib/action_dispatch/middleware/templates/rescues/template_error.html.erb within rescues/layout (70.4ms)
```

There is a lot of information here, and this is not even a very long stack trace. Your steps to diagnose the problem are:

> #### Steps to Diagnose a Stack Trace
1. Don't panic.
1. READ. Slowly read the error message to see if you understand it.
1. READ/compare. If you don't, work through the stack trace, comparing it to your code.







* Error types to explore:
  * SyntaxError
  * NameError
    * NoMethodError
  * KeyError
  * ArgumentError
  * TypeError


Ideas:
* explore a stack trace
  * look at the top!
* fix an error but get another error
  * explain when and why this can be a good thing
