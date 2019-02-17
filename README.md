[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/nystudio107/dotenvy/badges/quality-score.png?b=v1)](https://scrutinizer-ci.com/g/nystudio107/dotenvy/?branch=v1) [![Code Coverage](https://scrutinizer-ci.com/g/nystudio107/dotenvy/badges/coverage.png?b=v1)](https://scrutinizer-ci.com/g/nystudio107/dotenvy/?branch=v1) [![Build Status](https://scrutinizer-ci.com/g/nystudio107/dotenvy/badges/build.png?b=v1)](https://scrutinizer-ci.com/g/nystudio107/dotenvy/build-status/v1) [![Code Intelligence Status](https://scrutinizer-ci.com/g/nystudio107/dotenvy/badges/code-intelligence.svg?b=v1)](https://scrutinizer-ci.com/code-intelligence)

# Dotenvy

Speed up your production sites by ditching .env for key/value variable pairs as Apache, Nginx, and shell equivalents

## Requirements

PHP 7.0 or later, and a project that uses [Composer](https://getcomposer.org/)

## Installation

To install this package, follow these instructions.

1. Open your terminal and go to your project:

        cd /path/to/project

2. Then tell Composer to require the package:

        composer require nystudio107/dotenvy

## Dotenvy Overview

Dotenvy is a small tool that takes the contents of your `.env` file, and outputs them in a format that can be pasted directly into an Apache server config, Nginx server config, or shell CLI `.bashrc`

Why? Because as per the [phpdotenv](https://github.com/vlucas/phpdotenv) documentation:

> phpdotenv is made for development environments, and generally should not be used in production. **In production, the actual environment variables should be set so that there is no overhead of loading the .env file on each request.** This can be achieved via an automated deployment process with tools like Vagrant, chef, or Puppet, or can be set manually with cloud hosts like Pagodabox and Heroku.
  
  The `.env` file is meant to be a convenience to make things easier to change in local development environments.
  
  What the [phpdotenv](https://github.com/vlucas/phpdotenv) package does is parse your `.env` file, and then call [putenv()](http://php.net/manual/en/function.putenv.php) to set each environment variable. This sets the [$_ENV superglobal](http://php.net/manual/en/reserved.variables.environment.php) that your application can later read in via [getenv()](http://php.net/manual/en/function.getenv.php).
  
  Using the technique described here, the exact same `$_ENV` superglobal gets set with your environmental variables, and are made available via the same `getenv()` function. The difference is that your webserver or CLI sets the variables directly, without having to parse the `.env` file. 
  
  This is a partial implementation of feature I've been hoping to have in Craft CMS core in some fashion: [Add `craft config/cache` as a console command](https://github.com/craftcms/cms/issues/1607)
  
## Using Dotenvy

From your project's root directory that contains the `.env` and `/vendor` directory, do:

```bash
vendor/nystudio107/dotenvy/src/dotenvy
```

If you're on Windows, do:
```bash
vendor/nystudio107/dotenvy/src/dotenvy.bat
```

If your `.env` file lives somewhere else, you can pass in the directory to the `.env` file:

```bash
vendor/nystudio107/dotenvy/src/dotenvy /path/to/some/dir/
```

Then **do not create** a `.env` file on your production environment, instead paste or insert via a deployment system the resulting file that Dotenvy generates for you.

In this way, the appropriate `.env` variables will be automatically injected by your Apache server, or Nginx server, or via CLI.

This means that the `.env` file no longer needs to be parsed on every request.

### Updating `.gitignore`

Make sure you `.gitignore` all of the `.env*` files with a line like this in your root project `.gitignore` file:

```
.env*
```
...to ensure that none of your secrets in the generated `.env*` files are checked into git. Note the trailing `*`

### Example `.env` file

Given a `.env` file that looks like this:

```bash
# The environment Craft is currently running in ('dev', 'staging', 'production', etc.)
ENVIRONMENT="local"

# The secure key Craft will use for hashing and encrypting data
SECURITY_KEY="jMgCxHuaM1g3qSzHiknTt5S8gDy5BNW7"

# The database driver that will be used ('mysql' or 'pgsql')
DB_DRIVER="mysql"

# The database server name or IP address (usually this is 'localhost' or '127.0.0.1')
DB_SERVER="localhost"

# The database username to connect with
DB_USER="homestead"

# The database password to connect with
DB_PASSWORD="secret"

# The name of the database to select
DB_DATABASE="craft3"

# The database schema that will be used (PostgreSQL only)
DB_SCHEMA="public"

# The prefix that should be added to generated table names (only necessary if multiple things are sharing the same database)
DB_TABLE_PREFIX=""

# The port to connect to the database with. Will default to 5432 for PostgreSQL and 3306 for MySQL.
DB_PORT="3306"
```

The following files will be output in the same directory as the `.env` file:

#### Apache `.env_apache.txt`

Paste these inside the `<VirtualHost>` block

```apacheconfig
# Apache .env variables
# Paste these inside the <VirtualHost> block:
SetEnv    ENVIRONMENT             "local"
SetEnv    SECURITY_KEY            "jMgCxHuaM1g3qSzHiknTt5S8gDy5BNW7"
SetEnv    DB_DRIVER               "mysql"
SetEnv    DB_SERVER               "localhost"
SetEnv    DB_USER                 "homestead"
SetEnv    DB_PASSWORD             "secret"
SetEnv    DB_DATABASE             "craft3"
SetEnv    DB_SCHEMA               "public"
SetEnv    DB_TABLE_PREFIX         ""
SetEnv    DB_PORT                 "3306"
```

#### Nginx `.env_nginx.txt`

Paste these inside the `server {}` or `location ~ \.php {}` block or in the `fastcgi_params` file

```apacheconfig
# Nginx .env variables
# Paste these inside the server {} or location ~ \.php {} block or in the fastcgi_params file:
fastcgi_param    ENVIRONMENT             "local";
fastcgi_param    SECURITY_KEY            "jMgCxHuaM1g3qSzHiknTt5S8gDy5BNW7";
fastcgi_param    DB_DRIVER               "mysql";
fastcgi_param    DB_SERVER               "localhost";
fastcgi_param    DB_USER                 "homestead";
fastcgi_param    DB_PASSWORD             "secret";
fastcgi_param    DB_DATABASE             "craft3";
fastcgi_param    DB_SCHEMA               "public";
fastcgi_param    DB_TABLE_PREFIX         "";
fastcgi_param    DB_PORT                 "3306";
```

#### CLI (Bash shell) `.env_cli.txt`

Paste these inside your `.bashrc` file in your `$HOME` directory:

```bash
# CLI (bash) .env variables
# Paste these inside your .bashrc file in your $HOME directory:
export ENVIRONMENT="local"
export SECURITY_KEY="jMgCxHuaM1g3qSzHiknTt5S8gDy5BNW7"
export DB_DRIVER="mysql"
export DB_SERVER="localhost"
export DB_USER="homestead"
export DB_PASSWORD="secret"
export DB_DATABASE="craft3"
export DB_SCHEMA="public"
export DB_TABLE_PREFIX=""
export DB_PORT="3306"
```

## The Craft CMS CLI

Note that if you set the `.env` variables directly in your Apache or Nginx config, these variables will **not** be available using the Craft CMS `./craft` CLI command.

That's because the webserver doesn't run at all for CLI requests. Instead, you'll need to add them to your `.bashrc` file as noted above, or you can use the Unix [source](https://bash.cyberciti.biz/guide/Source_command) command, e.g:

```bash
source .env_cli.txt && ./craft migrate/all
```

In the above example, the `source` command will execute the `export` statements in the `.env_cli.txt` and then run the `./craft` executable with those environmental variables set.

This pattern is useful if you are running multiple sites on a single instance, and so setting the `.env` variables globally for a user via `.bashrc` doesn't make sense.
 
## Dotenvy Roadmap

Some things to do, and ideas for potential features:

* Release it

Brought to you by [nystudio107](https://nystudio107.com/)
