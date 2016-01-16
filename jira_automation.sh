#!/bin/bash

if [ "$1" == "-M" -o "$1" == "-m" ] ; then
  echo "For adding a CVS : <command> -a/-A"
  echo "For resetting config : <command> -r/-R"
  echo "For modifying config : <command> -c/-C"
  echo "For committing file wise : <command> -f/-F {file...}"
  exit
fi


if [ "$1" == "-r" -o "$1" == "-R" ];then
  echo "Resetting all configuration, proceed?"
  PROMPT="Yes No"
  select ans in $PROMPT; do
    if [ "$ans" == "Yes" ];then
      > ~/jira_automation/jira_automation.conf
      echo "Config Resetted"
    else break 2
    fi
    break 2
  done 
fi

if [ "$1" == "-a" -o "$1" == "-A" ];then
  read -p 'Enter a versioning system(ex: GIT, SVN, HG): ' CSV
  echo "$CSV added as a Verson Controlling System"
  mkdir ~/jira_automation/"$CSV"_LOG
  echo "$CSV"='"CSV"' >> ~/jira_automation/jira_automation.conf
fi

if [ "$1" == "-c" -o "$1" == "-C" ];then
  vim ~/jira_automation/jira_automation.conf
fi


source ~/jira_automation/jira_automation.conf
file="jira_automation.txt"

if [ -z "$Username" ];then
  read -p 'Jira Username: ' Username
  read -sp 'Jira Password: ' Password
  echo 'Username="'$Username'"' >> ~/jira_automation/jira_automation.conf
  echo 'Password="'$Password'"' >> ~/jira_automation/jira_automation.conf
fi

if [ -z "$CSV" ];then
  echo
  echo "Do you use Version Controlling System?"
  PROMPT="Git Svn Mercurial None"
  select ans in $PROMPT; do
    if [ "$ans" == "Git" ];then
      if [ -z "$GIT" ];then
        GIT="CSV"
        mkdir ~/jira_automation/GIT_LOG
        echo 'GIT="CSV"' >> ~/jira_automation/jira_automation.conf
      fi
      break 2
    elif [ "$ans" == "Svn" ];then
      if [ -z "$SVN" ];then
        SVN="CSV"
        mkdir ~/jira_automation/SVN_LOG
        echo 'SVN="CSV"' >> ~/jira_automation/jira_automation.conf
      fi
      break 2
    elif [ "$ans" == "Mercurial" ];then
      Mercurial="CSV"
      echo 'CSV="Mercurial"' >> ~/jira_automation/jira_automation.conf
      break 2
    else
      None="CSV"
      echo 'CSV="None"' >> ~/jira_automation/jira_automation.conf
      break 2
    fi
    break 2
  done
fi

if [ -z "$CSV" ];then
  echo 'CSV="DONE"' >> ~/jira_automation/jira_automation.conf
fi

if [ -z "$DEFAULT" ];then
  echo
  echo "Please select a Project:"
  OPTIONS="Proj1 Proj2 Proj3 Proj4 Proj5 Something_Else"
  select opt in $OPTIONS; do
     if [ "$opt" == "SMP" ]; then
      CHOSEN="Proj1"
      if [ -z "$Proj1" ];then
        echo "Do you want $CHOSEN to set as default?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
            if [ "$ans" == "Yes" ];then
              echo SMP set as default
              DEFAULT="Proj1"
              echo 'DEFAULT="Proj1"' >> ~/jira_automation/jira_automation.conf
              break 2
            else
              echo 'Proj1="FLAGGED"' >> ~/jira_automation/jira_automation.conf
              break 2
            fi
          done
        fi
      break 2
     elif [ "$opt" == "Proj2" ]; then
      CHOSEN="Proj2"
      if [ -z "$Proj2" ];then
        echo "Do you want $CHOSEN to set as default?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
            if [ "$ans" == "Yes" ];then
              echo Proj2 set as default
              DEFAULT="Proj2"
              echo 'DEFAULT="Proj2"' >> ~/jira_automation/jira_automation.conf
              break 2
            else
              echo 'Proj2="FLAGGED"' >> ~/jira_automation/jira_automation.conf
              break 2
            fi
          done
        fi
      break 2
     elif [ "$opt" == "Proj3" ]; then
      CHOSEN="Proj3"
      if [ -z "$Proj3" ];then
        echo "Do you want $CHOSEN to set as default?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
            if [ "$ans" == "Yes" ];then
              echo Proj3 set as default
              DEFAULT="Proj3"
              echo 'DEFAULT="Proj3"' >> ~/jira_automation/jira_automation.conf
              break 2
            else
              echo 'Proj3="FLAGGED"' >> ~/jira_automation/jira_automation.conf
              break 2
            fi
          done
        fi
      break 2
     elif [ "$opt" == "Proj4" ]; then
      CHOSEN="Proj4"
      if [ -z "$Proj4" ];then
        echo "Do you want $CHOSEN to set as default?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
            if [ "$ans" == "Yes" ];then
              echo Proj4 set as default
              DEFAULT="Proj4"
              echo 'DEFAULT="Proj4"' >> ~/jira_automation/jira_automation.conf
              break 2
            else
              echo 'Proj4="FLAGGED"' >> ~/jira_automation/jira_automation.conf
              break 2
            fi
          done
        fi
      break 2
      elif [ "$opt" == "Proj5" ]; then
      CHOSEN="Proj5"
      if [ -z "$Proj5" ];then
        echo "Do you want $CHOSEN to set as default?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
            if [ "$ans" == "Yes" ];then
              echo SR set as default
              DEFAULT="Proj5"
              echo 'DEFAULT="Proj5"' >> ~/jira_automation/jira_automation.conf
              break 2
            else
              echo 'Proj5="FLAGGED"' >> ~/jira_automation/jira_automation.conf
              break 2
            fi
          done  
        fi
      break 2
    elif [ "$opt" == "Something_Else" ]; then
      read -p "Enter the Project Name : " CHOSEN
      if [ -z "$CHOSEN" ];then
        echo "Do you want $CHOSEN to set as default?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
            if [ "$ans" == "Yes" ];then
              echo "$CHOSEN" set as default
              DEFAULT="$CHOSEN"
              echo 'DEFAULT="$CHOSEN"' >> ~/jira_automation/jira_automation.conf
              break 2
            else
              echo '$CHOSEN="FLAGGED"' >> ~/jira_automation/jira_automation.conf
              break 2
            fi
          done  
        fi
      break 2
     else
      echo bad option, try again.
     fi
done
fi

if [ -z "$CHOSEN" ];then
  CHOSEN="$DEFAULT"
fi

> $file

curl -s -X POST -H "Authorization: Basic $(echo -n $Username:$Password | base64)" -H "Content-Type: application/json" --data '{"jql":"project = '"'$CHOSEN'"' and assignee = '"'$Username'"' and resolution = unresolved","startAt":0,"maxResults":3,"fields":["key"]}' "https://your_ip/rest/api/2/search" > $file

python -c "file_content = open('jira_automation.txt', 'r')
content = file_content.read()
open('jira_automation.txt', 'w').close()
x = open('jira_automation.txt', 'w')
for i in (eval(content))['issues']:
    x.write(i['key'])
    x.write(' ')
x.close()
"

while IFS='' read -r line || [[ -n "$line" ]]; do
    SELECT_TICKET="$line"
done < "$file"

if [ -z "$SELECT_TICKET" ];then
  read -p "Oops, something went wrong, Enter issue no.: " CHOSEN_TICKET
else
  SELECT_TICKET="$SELECT_TICKET None_of_the_above"
  echo "Select an Issue: "
  stringarray=($SELECT_TICKET)
  select ticket in $SELECT_TICKET; do
    if [ "$ticket" == "${stringarray[0]}" ]; then
     CHOSEN_TICKET="${stringarray[0]}"
    elif [ "$ticket" == "${stringarray[1]}" ]; then
     CHOSEN_TICKET="${stringarray[1]}"
    elif [ "$ticket" == "${stringarray[2]}" ]; then
     CHOSEN_TICKET="${stringarray[2]}"
    else 
      read -p 'Enter issue no. : ' CHOSEN_TICKET
      break
    fi
    break
  done
fi

if [ "$GIT" -a -d ".git" ];then
    if [ "$1" == "-f" -o "$1" == "-F" ];then
      echo "Iterating through files selected:"
      FILE_TO_COMMIT=''
      for var in "$@"
      do
        if [ "$var" != "-f" ];then
          echo "Diffing $var:\n"
          git diff "$var"
          echo "Diff Checked, ready to Commit?"
          PROMPT="Yes No"
          select ans in $PROMPT; do
              if [ "$ans" == "Yes" ];then
                git add "$var"
                FILE_TO_COMMIT="$FILE_TO_COMMIT $var"
                break
              elif [ "$ans" == "No" ];then
                echo "$var will not be committed !!!"

                break 
              else
                echo "Please enter correct value" 
              fi
          done
        fi
      done
    else
      FILE_TO_COMMIT=''
      ALL_FILE=$(git status -s | awk '{if ($1 == "M") print $2}')
      for i in $ALL_FILE; do
        echo
        echo "Diffing $i:\n"
        git diff "$i"
        echo "Diff Checked, ready to Commit?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
          if [ "$ans" == "Yes" ];then
            git add "$i"
            FILE_TO_COMMIT="$FILE_TO_COMMIT $i"
            break
          elif [ "$ans" == "No" ];then
            echo "$i will not be committed !!!"
            break 
          else
            echo "Please enter correct value"
          fi
        done
      done
    fi
    if [ "$FILE_TO_COMMIT" ];then
      COUNTER=1
      echo "Committing following files : "
      for i in $(echo $FILE_TO_COMMIT | sed "s/,/ /g"); do
        echo "$COUNTER) $i"
        COUNTER=$[$COUNTER +1]
      done
      read -p "Enter Worklog Comment/Commit Message: " COMMENT
      while [ -z "$COMMENT" ];do
        read -p "Enter Worklog Comment/Commit Message(Can't be blank): " COMMENT
      done
      git commit -m "$CHOSEN_TICKET : $COMMENT" >> "$CSV_automation.log"
      echo "git commit -m '"$CHOSEN_TICKET : $COMMENT"' $FILE_TO_COMMIT" > ~/jira_automation/GIT_LOG/gitlog
    else
      echo "Nothing to Commit !!!"
    fi
fi

if [ "$SVN" ]; then
  if [ -d ".svn" ];then
    if [ "$1" == "-f" -o "$1" == "-F" ];then
      echo "Iterating through files selected:"
      FILE_TO_COMMIT=''
      for var in "$@"
      do
        if [ "$var" != "-f" ];then
          echo "Diffing $var:\n"
          svn diff "$var"
          echo "Diff Checked, ready to Commit?"
          PROMPT="Yes No"
          select ans in $PROMPT; do
              if [ "$ans" == "Yes" ];then
                FILE_TO_COMMIT="$FILE_TO_COMMIT $var"
                break
              elif [ "$ans" == "No" ];then
                echo "$i will not be committed !!!"
                break 
              else
                echo "Please enter correct value" 
              fi
          done
        fi
      done
    else
      FILE_TO_COMMIT=''
      ALL_FILE=$(svn status | awk '{if ($1 == "M") print $2}')
      for i in $ALL_FILE; do
        echo
        echo "Diffing $i:\n"
        svn diff "$i"
        echo "Diff Checked, ready to Commit?"
        PROMPT="Yes No"
        select ans in $PROMPT; do
          if [ "$ans" == "Yes" ];then
            FILE_TO_COMMIT="$FILE_TO_COMMIT $i"
            break
          elif [ "$ans" == "No" ];then
            echo "$i will not be committed !!!"
            break 
          else
            echo "Please enter correct value"
          fi
        done
      done
    fi
    if [ "$FILE_TO_COMMIT" ];then
      COUNTER=1
      echo "Committing following files : "
      for i in $(echo $FILE_TO_COMMIT | sed "s/,/ /g"); do
        echo "$COUNTER) $i"
        COUNTER=$[$COUNTER +1]
      done
      read -p "Enter Worklog Comment/Commit Message: " COMMENT
      while [ -z "$COMMENT" ];do
        read -p "Enter Worklog Comment/Commit Message(Can't be blank): " COMMENT
      done
      svn ci -m '"$CHOSEN_TICKET : $COMMENT"' $FILE_TO_COMMIT
      echo "svn ci -m '"$CHOSEN_TICKET : $COMMENT"' $FILE_TO_COMMIT" > ~/jira_automation/SVN_LOG/svnlog
    else
      echo "Nothing to commit!!!"
    fi
  fi
fi

read -p "Enter Timespent: " TIMESPENT
while [ -z "$TIMESPENT" ];do
  read -p "Enter Timespent(Can't be blank): " TIMESPENT
done
if [[ $TIMESPENT =~ (([0-9]*h)|([0-9]*m)|([0-9]h [0-9]{1,2}m)) ]]; then
  :
else
  read -p "Enter Timespent (e.g. 1h, 30m, 1h 20m) : " TIMESPENT
fi

if [ ! -d ".git" -a ! -d ".svn" ];then
  read -p "Enter Worklog Comment: " COMMENT
  while [ -z "$COMMENT" ];do
    read -p "Enter Worklog CommentCan't be blank): " COMMENT
  done
fi

COMMENT="(This is an automated comment) $COMMENT"

response=$(curl -s -D- -X POST -H "Authorization: Basic $(echo -n $Username:$Password | base64))" -H "Content-Type: application/json" -d '{"comment": "'"$COMMENT"'","timeSpent": "'"$TIMESPENT"'"}' https://your_ip/rest/api/2/issue/$CHOSEN_TICKET/worklog)
echo "alias jal='bash ~/jira_automation/jira_automation.sh'" >> ~/.bash_alias
source ~/.bash_alias
rm "$file"
