if [ -d .bash ]; then
  rm -rf .bash
fi
if [ -f .vimrc ]; then
  rm .vimrc
fi
cp -r ~/.bash .
cp ~/.vimrc .

git status
