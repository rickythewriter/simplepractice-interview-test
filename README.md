SimplePractice Programming Test
=======================

The goal of the SimplePractice programming test is to evaluate the programming abilities
of candidates. The ideal candidate would know Ruby, JavaScript, or another language with
great proficiency, be familiar with basic database and HTTP API principles, and able to
write clean, maintainable code. This test gives candidates a chance to show these
abilities.

Getting Your Environment Ready
------------------------------

You'll need a development computer with access to github.com. You'll also need to set up
Docker CE (https://www.docker.com/community-edition), which is free. Sample `Dockerfile`
and `docker-compose.yml` files are included in this repo along with a basic scaffolded
Rails application.

There is a `Makefile` included for your convenience that has sample commands for building
and managing your application via the command line.

Please make sure you can bring up your app with `make up` well before the start of the
test. You should be able to run the tests if the basic setup works.

```bash
$ make
$ make build
$ make dbcreate
$ make test
```

If you need to use generators with docker:

```bash
docker-compose run app bundle exec rails scaffold users
```

Or, alternatively, you can "ssh" into the container (to exit, type `exit` or `ctrl + d`)

```bash
$ make bash
$ bundle exec rails g scaffold users
```

**NOTE** since the generator runs inside of Docker (and this container runs as
the `root` user), you will need to change the permissions of the generated
files. The following command is added as a convenience and should be run after
generated files are created to avoid "write permission" failures.

```bash
sudo chown -R $USER .
```

OR

```bash
make chown
```

Evaluation Criteria
-------------------

When evaluating the program, the following are among the factors considered:

 * Does it run?
 * Does it produce the correct output?
 * How did _you_ gain confidence your submission is correct?
 * Were appropriate algorithms and data structures chosen?
 * Was it well written? Are the source code and algorithms implemented cleanly?
   Would we enjoy your code living along side our own?
 * Is it slow? For small to medium sized inputs, the processing delay should
   probably not be noticeable.
   
   
Ricky Thang's Comments
----------------------

 * Does it run?

   Yes, all of them run.

 * Does it produce the correct output?

   Minimum requirements have been met.

   I would have liked to make the following improvements, if there were more time:

   Requirement 1:
   - Seed appointment start_times to be on the hour or half-hour.
   - Remove prefixes (such as Mr. Mrs. Rev.) from dummy names.

   Requirement 5:
    - Return error messages when validations have not been passed.
    - Write a validation to prevent duplicate appointments.

 * How did _you_ gain confidence your submission is correct?

   I tested each requirement manually, and thoroughly.
   However, if time permitted, I would've also attempted writing spec tests, as I find this modular approach more organized.

 * Were appropriate algorithms and data structures chosen?

   Yes, as there were no operations with a slow time complexitiy, such as O(n^2).

 * Was it well written? Are the source code and algorithms implemented cleanly?
   Would we enjoy your code living along side our own?

   As a professional writer, attention to readability (particularly "skim"-ability) is evident in my submission. 
   Though, any draft could be improved, with more editing.
   
   Also consider that:
   - I had no prior experience with Ruby. I learned it over the Independence Day holiday weekend. 
   - Notice my attention to idiomatic style, e.g. helper methods for controllers are written within model classes.

 * Is it slow? For small to medium sized inputs, the processing delay should
   probably not be noticeable.
   
   No, as most of the operations used were in linear time, at the slowest.

