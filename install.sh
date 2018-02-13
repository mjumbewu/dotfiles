#!/usr/bin/env bash

SRCDIR=$(dirname $0)

# Back up the current .bashrc
echo "Backing up .bashrc..."
cp "$HOME/.bashrc" "$HOME/.bashrc.$(date -Iseconds)"

# Move dotfiles into place
echo "Creating additional .bash files..."
cp $SRCDIR/.bash_aliases $HOME/.bash_aliases
cp $SRCDIR/.bash_prompt $HOME/.bash_prompt
cp $SRCDIR/.bash_custom $HOME/.bash_custom


# Add an reference to .bash_aliases to the .bashrc if it does not yet exist.
echo "Adding reference to .bash_aliases..."
if ! grep -q ".bash_aliases" $HOME/.bashrc; then
  cat >> $HOME/.bashrc <<EOF

# Alias definitions.
# You may want to put all your additions into a separate file like
# $HOME/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi
EOF
fi


# Add an reference to .bash_prompt to the .bashrc if it does not yet exist.
echo "Adding reference to .bash_prompt..."
if ! grep -q ".bash_prompt" $HOME/.bashrc; then
  cat >> $HOME/.bashrc <<EOF

# Prompt override.

if [ -f $HOME/.bash_prompt ]; then
    . $HOME/.bash_prompt
fi
EOF
fi


# Add an reference to .bash_custom to the .bashrc if it does not yet exist.
echo "Adding reference to .bash_custom..."
if ! grep -q ".bash_custom" $HOME/.bashrc; then
  cat >> $HOME/.bashrc <<EOF

# Other bash customizations.

if [ -f $HOME/.bash_custom ]; then
    . $HOME/.bash_custom
fi
EOF
fi


echo "Reloading .bashrc..."
source $HOME/.bashrc


echo "Done."
