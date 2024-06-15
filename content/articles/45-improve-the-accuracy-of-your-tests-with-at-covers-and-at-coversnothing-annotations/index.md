---
title: "Improve the accuracy of your tests with @covers and @coversNothing annotations"
date: 2018-02-19T22:00:00+02:00
draft: false
summary: "Code coverage results can give a false sense of quality. With the `@covers` and `@coversNothing` annotations, you can better express the intention of your test. This leads to better code coverage results that truly reflect the coverage of your tests."
types: ['tutorial']
subjects: ['testing', 'phpunit']
params:
  outdated_warning: true
---
Code coverage is the measure of how many lines of code your tests have covered. It is expressed as a percentage of the total lines of code in your project.

Because high coverage gives you shiny badges, you could be lead to believe that higher coverage is always better. And that is simply not the case.

## What coverage is really about

Code coverage is really about testing all the control flows in your code. Consider the example `foo` method that looks like this:

```php
public function foo($input)
{
    if ($input === false) {
        return 'foo';
    }
    return 'bar';
}
```

It is obvious that this method has two control flows: $input can be either `false` or something else. In both cases, we get a different return value. So, in order to test this method properly, we should test both scenarios.

Code coverage can help you visualize which lines have been tested. You might find that you have only tested the [happy path](https://en.wikipedia.org/wiki/Happy_path) but not the unhappy path that triggers an exception or produces different results.

So far, so good, but what does this have to do with annotations?

## The problem with code coverage

The main problem with code coverage is that it does not say anything about the quality of your tests. You could "cover" each line of code without writing meaningful tests that help you maintain your project.

Consider the following test example:

```php
class FooTest 
{
    /** @test */
    public function itOutputsBar()
    {
        $config = new Config();

        $foo = new Foo();

        $this->assertEquals('bar', $foo->getValue());
    }
}
```

To test the output of `Foo::getValue` we first have to initialize a `Config` and construct a new `Foo`. The code coverage outcome of this test would tell us that we have covered the following 3 methods:

* `Config::__construct()`
* `Foo::__construct()`
* `Foo::getValue()`

And this is where the problem lies. Our intention is to test `Foo::getValue()`. The rest of the coverage is only a byproduct of our real test and was not our goal for this test. It is a side-effect and in my view, this is not "true coverage".

## Towards true code coverage

The truthfulness of the code coverage output can be improved by using annotations. The [@covers annotation](https://phpunit.de/manual/current/en/appendixes.annotations.html#appendixes.annotations.covers) can be added to a test class or a test method. Multiple annotations can be used per class or method.

`@covers \App\Foo` indicates that we test the `Foo` class.

`@covers \App\Foo::getValue()` indicates that we test the `getValue` method of the `Foo` class.

Any side effect of the test will no longer count as code coverage. This increases clarity and intentionality.

## Exclude tests from code coverage

In other cases, it might be best to exclude a test from code coverage completely. Maybe you have a single big integration test that uses all components from front to end.

You can accomplish this by adding the [@coversNothing annotation](https://phpunit.de/manual/current/en/appendixes.annotations.html#appendixes.annotations.coversNothing) to that class or method.