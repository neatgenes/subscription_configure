IMORTANT NOTE: I wouldn't use this just yet. I'll give a fully working version soon. It's nearly done though!

UPDATE: I've updated this to where the file location and directory needed for the app to run is now in a variable so it's easier for users to change if needed. I've also fixed a bug which was a small typo on a command. So far it's working as intended. 

This tool is still in the works, but it is being designed and tested for RedHat 8 and 9 systems. I imagine it would work on previous versions but haven't looked into that just yet.
I created this primarily because I've been creating local repositories for my RHCE studies in Ansible automation and I found it's easier just to disable my repository subscriptions
rather than going in and disabling RedHat from auto-generating it's repo config and the file it generates. It's pretty useful if you disable and re-enable repo subscriptions quite a bit.


Here is a run down of how this works and how you can use it:

Initially you'll be greeted with a screen that gives you a list of options that you can perform. Your screen will look different if it's your first time using it because it requires a "subscriptions" directory
that contains a file called repos.txt with content to continue. If you don't have these files the script will generate them for you, but it will ask you if that's ok first.
![image](https://github.com/user-attachments/assets/3937f614-d528-429f-89ae-8ca7e1410a0d)

This app will always generate /subscriptions/repos.txt to your home directory. As it is now, I haven't placed this in a variable and that line is repeated throughout the code, but I will eventually just set it 
as a variable so you can change that to whatever you want later.

Gather repository subscriptions
- This will create the directory and file you need and then check your enabled repo subscriptions and place them in a file called repos.txt. The reason it does this is so you can disable repos subscriptions
  without having to worry about remembering what subscriptions to re-enable later.

Disable repository subscriptions 
- This does pretty much what it sounds like. It disables all of your repo subscriptions.

Enable repository subscriptions
- Here's where the repos.txt file comes into play. This will run a for loop to enable all your repos again. These will be the repos you were subscribed to initially.

Check your enabled repository subscriptions
- This will run subscription-manager repos --list-enabled and provide you with the output

Check your "repos.txt" file content
- This shows the output of the file the script generated in case you want to make sure it contains all of your repos. This is a good idea to do since if there's any errors during the initial generation of the file,
  you can determine that here.

  
