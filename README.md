

## Prerequisites
* variables
* methods


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

These lines, in combination with the first, are what we call a `stack trace`. The top of the 'stack' always contains the source of the actual error. This is often enough to solve the problem. The rest of the stack, from top to bottom, indicates the methods that have been called that led to the error. Let's work bottom to top to explore how this worked.

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
