---
title: "How to create and configure a custom module in Codeception"
date: 2017-02-10T19:00:00+02:00
draft: false
summary: "This post explains how you can create and configure a custom module for Codeception. This is the easiest way to extend on Codeception in a reusable way."
types: ['tutorial']
subjects: ['testing', 'configuration', 'tools', 'codeception']
params:
  outdated_warning: true
---
Codeception is a testing framework with many functionalities. These functionalities are bundled in so-called modules. Some modules are used in most tests, like the [Asserts module](http://codeception.com/docs/modules/Asserts). Other provide more specific functions,  like the [Laravel5 module](http://codeception.com/docs/modules/Laravel5) or the [Filesystem module](http://codeception.com/docs/modules/Filesystem).

## Why would you?
For a recent project, I had to import existing news items into a new website without database access. So I decided to use Codeception's acceptance testing tool to automate the process.

During the process, some modules had to be extended to allow for my need. For example, the [database module](http://codeception.com/docs/modules/Db) has a method for retrieving a record from the database. What I needed was a method to retrieve all records from the database, which is a small extension.

## Create a module
A very basic module for Codeception looks something like this:

`/tests/_support/Helper/MyModule.php`:
```php
<?php

namespace Helper;

class MyModule extends \Codeception\Module
{

    /** @var array */
    protected $config = [
        'foo' => true,
    ];

    /**
     * HOOK:
     * triggered after module is created and configuration is loaded
     */
    public function _initialize()
    {
        // ...
    }
}
```

A module has multiple hooks that allow you to act on certain key events in the testing cycle:
* _beforeSuite($settings = [])
* _afterSuite()
* _beforeStep(Step $step)
* _afterStep(Step $step)
* _before(TestInterface $test)
* _after(TestInterface $test)
* _failed(TestInterface $test, $fail)
* _cleanup()

Read more about [hooks in the docs](http://codeception.com/docs/06-ModulesAndHelpers#Hooks).

## Extending modules
Of course, it is also possible to extend on existing modules, which is what I did myself. Instead of extending `\Codeception\Module` you can extend `\Codeception\Module\Db` or any other module. Then it is possible to alter methods or add your own.

`/tests/_support/Helper/ExtendedDb.php`:

```php
<?php

namespace Helper;

class ExtendedDb extends \Codeception\Module\Db
{
    public function grabRowsFromDatabase($table, $criteria = [])
    {
        // ...
    }
}
```

## Configuring custom modules
Modules can be enabled in the global configuration (using codeception.yml) or on a specific suite (using, for example, acceptance.suite.yml).

My `acceptance.suite.yml` configuration currently looks something like this:

```yml
class_name: AcceptanceTester
modules:
    enabled:
        - \Helper\Acceptance
        - \Helper\ExtendedDb
        - Asserts
    config:
        \Helper\ExtendedDb:
            dsn: "mysql:host=%DB_HOST%:%DB_PORT%;dbname=%DB_DATABASE%"
            user: "%DB_USERNAME%"
            password: "%DB_PASSWORD%"
```

As you can see this configuration is the same as for the default Db module. Any of the configuration variables is available within the module on the `$this->config` class variable.

Read more about [modules and helpers in the official docs](http://codeception.com/docs/06-ModulesAndHelpers).