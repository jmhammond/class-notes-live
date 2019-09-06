STYLESHEETS_DIR = ~/src/mathbook/xsl

html:
	xsltproc --xinclude --stringparam html.knowl.example no --stringparam html.knowl.proof no -stringparam html.google-search 015422183392601792159:vae7vvmmczm $(STYLESHEETS_DIR)/mathbook-html.xsl class-notes.xml

all: html pdf

colorscheme:
	xsltproc --xinclude --stringparam html.knowl.example no --stringparam html.css.file "mathbook-manitoba.css" $(STYLESHEETS_DIR)/mathbook-html.xsl class-notes.xml


tex:
	xsltproc --xinclude --stringparam exercise.divisional.solution no --stringparam exercise.divisional.answer no ./xsl/latex.xsl class-notes.xml > discrete-class-notes.tex

pdf: tex
	pdflatex discrete-class-notes.tex && pdflatex discrete-class-notes.tex

clean:
	rm -f *.out *.toc *.html *.aux *.log discrete-class-notes.pdf discrete-class-notes.tex

publish-to-web: html
	rsync -zartv --include "*/" --include="*.html" --exclude="*" ./  ~/public_html/class-notes

online: html
	rsync -zartv --include "*/" --include="*.html" --exclude="*" ./  ~/public_html/math321

staging: html
	rsync -zartv --include "*/" --include="*.html" --exclude="*" ./  ~/public_html/notes-staging

publish:
	ssh hammond@alonzo.math.wichita.edu 'cd src/class-notes && git pull && make publish-to-web'

images:
	~/src/mathbook/script/mbx -vv -c latex-image -f svg -d ~/Documents/class-notes/images ~/Documents/class-notes/class-notes.xml

# Here's the rsync command that probably works for me.
# rsync -zartv --include "*/" --include="*.html" --exclude="*" ./  ~/public_html/notes-staging

update-the-webs:
	echo "Updating wichita.edu/discretebook"
	git checkout master
	make publish-to-web
	echo "Updating wichita.edu/discreteOnline"
	git checkout onlineCourse
	make online
