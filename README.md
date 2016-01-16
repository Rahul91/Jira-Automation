# Jira-Automation
Commit usgin git/svn/mercurial, it will be autmatically logged to your Jira Ticket

#Summary:
Logging work to your assigned unresolved tickets, given that you are using atlassian Jira can be automated through cli.
The shell scripts automatically log work, in case of commit, eihter you are working on git or svn or Mercurial.
And even if you are not committing your code, maybe you worked on some documentation, or were reviewing code, you can log your work
using this script from your terminl.

#Key Features:
1. While committing your code, it first shows your diff and then asks you to proceed, therefore eliminating the chance of wrong commit.
2. Ticket no. is automatically apeneded in the commit message, which is a good practise.
3. Will work for git, svn and mercurial without having to write the hooks for doing the same.
4. Every step can be logged. for later debugging, if required.
5. While committing, there is a option of specifying files with -f option.
6. Reduce rework of logging your work in ticket assigned to you.

#Working:
1. Make an alias of the script, or just execute it once, it will create it. It will create a alias of jal(jira automated logging)
2. Thats it !!!

3. Just go to any directory with a git or svn project, just write the command name and it will start working.
It will start diffing all your modified code, and asks one-by-one, if you want to commit or not. Just write
                  
                  $ jal

4. You can specify files if you need, by 
                  
                  $ jal -f file1 file2 file3 ....

5. If you need to add a new Control Versioning System, just type jal -A/-a and add a new CVS.
                  
                  $ jal -a

6. For resetting your conf or changing your conf, do the following
                  
                  $ jal -c/-C(Changing) 
                  $ jal -r/-R(Resetting)

7. And if there is nothing to commit, just go in any directory which is not an active git, svn or mercurial directory and just hit for command
                  
                  $ jal

8. This time, it will prompt your ticket, you can enter time spent and worklog message, and it will be logged.

9. For watching all the settings

                    $ jal -M/-m 
                    For adding a CVS : <command> -a/-A
                    For resetting config : <command> -r/-R
                    For modifying config : <command> -c/-C
                    For committing file wise : <command> -f/-F {file...}
