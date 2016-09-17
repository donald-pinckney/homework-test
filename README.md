# How to Complete Homework

## Part 1: Setup Accounts
1. If you don't already have a GitHub account, make one: [https://github.com/join](https://github.com/join)

## Part 2: Download Software
1. Download VirtualBox: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
2. Download Vagrant: [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
3. Download the 1678 Vagrant configuration: [https://github.com/frc1678/vagrant-box/archive/master.zip](https://github.com/frc1678/vagrant-box/archive/master.zip), and save it somewhere safe on your computer (you will use this a lot).
4. Setup the Vagrant virtual machine. Using your terminal / command prompt:

	```
	cd path/to/where/you/downloaded/vagrant-box/
	vagrant up
	```
This will take a while (~ 20 minutes) to setup. Then, you can run the command:

	```
	vagrant ssh
	```
5. Make sure to setup your git name and email:

	```
	git config --global user.name "Your Name"
	git config --global user.email your_email@example.com
	```

## Part 3: Actually Write Code
1. On GitHub, fork this repository.
2. `git clone` your fork to your virtual machine.
3. Write some code, and frequently `git commit` and `git push`.
4. Use the testing scripts to see how many tests pass:<br />
	```
	testing/test_all.sh
	```
	or
	```
	testing/test_problem.sh [problem_name]
	```
5. Until either all the tests pass or your are satisfied, repeat steps 3 and 4.
6. When you have semi-complete work that you would like to submit (you can submit unlimited times later too), `git push` your latest code, and then open a pull request to this repository from your fork.
7. Look at the README on this repository to see your semi-official scores (this should be updated automagically).
8. At the due date, your fork will be cloned, and will be tested and looked through manually to ensure it is legit, and to give some human feedback on code structure.
