---
title: "What is a command bus and why should you use it?"
date: 2019-02-14T15:30:00+02:00
draft: false
summary: "This article explains the basic concepts of the command bus. Why should you use it and how? Pointers are given to advanced use cases and good resources."
types: ['tutorial']
subjects: ['engineering', 'laravel', 'commandbus']
params:
  outdated_warning: false
---
This article explains the basic concepts of the command bus. Why should you use it and how? Pointers are given to advanced use cases and good resources.

## Terminology

A **command** is an object that signals an intent, like `RegisterUser`.
The command is passed to the **command bus**.
The command bus will pass the command to a **handler**.
The handler will perform the required actions, like registering the user.

Now that we have introduced the building blocks, let's dive into the specifics.

## What is a command?

As mentioned before, a command signals a users intent. An example of a command is `RegisterUser`.

Commands should contain all necessary information to be executed. They are basically [DTO](https://en.wikipedia.org/wiki/Data_transfer_object)'s. Because commands encapsulate all the information needed to execute, they can be handled synchronously or asynchronously.

Let's look at a sample command:
```php
class RegisterUser
{
    public $username;
    public $password;

    public function __construct(string $username, string $password)
    {
        $this->username = $username;
        $this->password = $password;
    }
}
```

So, how are these commands executed?

## Command handlers

Commands are handled by command handlers. A command must be handled by exactly one handler. In this sense, it differs from *events*, where we don't care how many handlers (listeners) are involved.

An example:
```php
final class RegisterUserHandler
{
    public function __construct(UserRepository $repository)
    {
        $this->repository = $repository;
    }

    public function handle(RegisterUser $command)
    {
        $user= User::register(
            $command->username,
            $command->password
        );

        $this->repository->save($user);
    }
}
```

No unexpected things here, I hope. The handler needs some objects that can be injected using Dependency Injection. Then it handles the command, which is passed as an argument.

I've left out some of the "wiring" in this example. For now, it is unimportant whether the handler extends a `BaseHandler` or implements an interface.

## The command bus

The command bus matches commands to handlers. This matching can be done automatically by some kind of naming convention. Another option is to register the relationships on the command bus.

When a command is dispatched, the bus locates the handler and calls the `handle` method.

The interface of the command bus might look like this:
```php
interface CommandBusInterface
{
    public function subscribe(string $commandClassName, string $handlerClassName);

    public function dispatch(CommandInterface $command);
}
```

There are many command bus implementations available. There are [Tactician](http://tactician.thephpleague.com/) and [SimpleBus](http://docs.simplebus.io/en/latest/), for example. Laravel ships with a [queue](https://laravel.com/docs/5.7/queues) that is basically a command bus on steroids.

## Dispatching a command

Let's look at an example of how a command can be dispatched:
```php
final class RegistrationController
{
    public function __construct(CommandBusInterface $bus)
    {
        $this->bus = $bus;
    }

    public function register(Request $request)
    {
        $command = new RegisterUser($request->username, $request->password);

        $this->bus->subscribe(RegisterUser::class, RegisterUserHandler::class);

        $this->bus->dispatch($command);
    }
```

Again, this example is simplified. The request needs to be validated before usage. Also, subscribing commands and handlers is something you don't want to do in the controller. If you are working in Laravel, this could be done in a [ServiceProvider](/articles/34-laravel-service-provider-examples).

## Why should you use this?
### Decoupled
Commands are easy to reuse in different parts of your application.

The collection of commands provide an interface for how the application logic can be used. They form a barrier between the infrastructure-part (controllers, CLIcommands) and the domain logic of the application.

In this way, they also provide structure and predictability. It makes it easier for you and other developers where code belongs and how it should be used.

### Testable
Decoupled objects are easier to test. Create a command with test data and pass it to the handler. Then test if the appropriate actions have been performed.

By mocking the command bus we can test whether commands have been dispatched.

### Extendable
The command bus can be extended with new functionality. For example, commands can be wrapped in database transactions that revert all changes on failure. By switching to this extended command bus implementation, suddenly all commands can be handled in a better way.

## Downsides
Using a command bus adds complexity. If you only have to handle trivial use cases, adding a command bus might be over-engineering.

Commands can grow to enormous complexity, just like all objects. Respect the [SOLID principles](/articles/51-8-resources-to-learn-about-solid-design-principles). Introducing [events](https://matthiasnoback.nl/2015/01/from-commands-to-events/) can be a great way to decouple secondary actions from commands.

## Other resources
Matthias Noback wrote a great series about command buses. Part 1: [a wave of command buses](https://matthiasnoback.nl/2015/01/a-wave-of-command-buses/). Part 2: [responsibilities of the command bus](https://matthiasnoback.nl/2015/01/responsibilities-of-the-command-bus/). Part 3: [from commands to events](https://matthiasnoback.nl/2015/01/from-commands-to-events/).

Robert Basic gave a presentation called All aboard the Service Bus! Watch in on [YouTube](https://www.youtube.com/watch?v=9UCIR9UnsTo) or take a look at the [slides](https://speakerdeck.com/robertbasic/all-aboard-the-service-bus-2).

Shawn McCool presented about [Use Case Architecture](https://youtu.be/2_380DKU93U?t=430) in which he talks about layered architecture and the place of commands within that architecture.