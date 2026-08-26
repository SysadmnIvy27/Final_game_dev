'''
Augustus Mapes
Gitlab automation script
5/28/26

run in godot terminal using 'python tools/gitpush.py'
'''

import subprocess

def main():
    can_push = pull_repo()
    get_status()
    if can_push:
        push_to_repo()
    
    print("Exiting")

def pull_repo():
    pull = input("Pull project? (y/N): ")

    if pull.lower() == "y":
        subprocess.run("git pull")
        return False
    else:
        print("Not pulling.")
        return True

def get_status():
    subprocess.run("git status")

def push_to_repo():
    push = input("Push to Repo? (y/N): ")

    if push.lower() == "y":
        msg = input("\nCommit message: ")

        subprocess.run("git add .")
        subprocess.run(f'git commit -m "{msg}"')
        subprocess.run("git push")
    else:
        print("Not pushing")

main()