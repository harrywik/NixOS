#!/bin/sh

if [ "$EUID" -ne 0 ]; then
        echo "Run as root."
        exit 1
fi

repo_dir="/etc/nixos/"

cd "$repo_dir"

user="$SUDO_USER"
user_folder="/home/$user/.config/nixos"
local_origin="local-origin"
remote_origin="origin"

# Check if the remote exists
if git remote get-url "$local_origin" &>/dev/null; then
        echo "Remote '$local_origin' already exists."
else
        git remote add "$local_origin" "$user_folder"
        echo "Remote '$local_origin' added."
fi

echo ""

echo "Authenticating via ssh as user: $user"
remote=$(git remote -v | grep -v "$local_origin" | awk '{print $2}' | cut -d':' -f1 | sort -u)

echo ""

echo "remote: $remote"

echo ""

if sudo -u $user ssh -T "$remote" 2>&1 | grep -q "successfully authenticated"; then
        echo "✔ SSH authentication to remote succeeded!"
else
        echo "❌SSH authentication to remote failed!"
        exit 1
fi

echo ""

while getopts "m:" opt; do
        case "$opt" in
                m) msg="$OPTARG" ;;
                *) echo "Usage: $0 -m <message>" && exit 1 ;;
        esac
done

echo "Checking if nix-build is OK"
echo ""

output=$(nixos-rebuild dry-build)

if [ $? -ne 0 ]; then
        echo "❌ Error: NixOS configuration contains errors"
        echo "…"
        echo ""
        echo "$output"
        exit 1
fi 

echo "✔ Valid!"
echo "…"
echo ""
echo "$output"
echo ""

mkdir -p $user_folder

git add -A

git commit -m "$msg"

git push --force $local_origin main

cd $user_folder

group=$(id -gn $user)

chown -R "$user:$group" "$user_folder"

echo ""
echo "Pushing files…"
echo ""

sudo -u $user git push --force "$remote_origin" main

cd $repo_dir

exit 0
