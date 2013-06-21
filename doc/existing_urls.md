<pre>
GET requests
============
Wordsearch/Home           http://www.csse.monash.edu.au/~jwb/cgi-bin/wwwjdic.cgi?1C
Kanji lookup              .......................................................1B
Multi radical kanji       .......................................................1R
Example search            .......................................................10
Text glossing             .......................................................9T
Customize                 .......................................................19B

New examples (static)     http://www.csse.monash.edu.au/~jwb/cgi-bin/wwwjdic.cgi?14
User guide (static)       ...................................wwwjdicinf.html
Dictionaries (static)     ..................................................#dicfil_tag
Dictionary codes (static) ..................................................#code_tag
Donations (static)        ..................................................#don_tag

Enter new entry           http://www.edrdg.org/jmdictdb/cgi-bin/edform.py?svc=jmdict&c=1


POST forms
==========
____________________
Wordsearch (GET ?1C)
    url http://www.csse.monash.edu.au/~jwb/cgi-bin/wwwjdic.cgi?1E
    fields
  * text_field dsrchkey                   - word input
  * select     dicsel                     - dictionary select
    * options           1-9,A-Q           - dictionary options
  * submit     search
  * reset      reset                      - javascript clear?
  * check_box  dsrchtype  J      #cform1  - romanized japanesse
  * check_box  engpri     X      #cform2  - restrict to common words
  * check_box  engpri     X      #cform2  - restrict to common words
  * check_box  exactm     X      #cform3  - exact match
  * check_box  firstkanj  X      #cform4  - match first kanji

______________________
Text glossing (GET ?9T)
  url POST ?9U
  fields
  * text_area gloss_line
  * submit    Begin Translation
  * reset      reset                      - javascript clear?
  * check_box  spantext    off            - hidden translations
  * select     dicsel                     - dictionary select
    * options             1-9,A-Q         - dictionary options
  * text_field  glleng      60            - hidden translations
  * check_box  glonekoff    on            - no single-character matches
  * check_box  geolhonour   on            - break on end of line
  * check_box  glduptr      on            - no repeated translations
  * check_box  glossonly    off           - only list translations
  * check_box  skipkata     off           - skip katakana words
  * check_box  skiphira     off           - skip hiragana words
  * check_box  skipname     off           - skip names

______________________
Text glossing URL(GET ?9T)
  url POST ?9V
   fields
  * text_field tran_url                   - URL to gloss text of
  * submit     Send URL
  * reset      reset                      - javascript clear?
  * check_box  spantext  off              - hidden translations
  * select     dicsel                     - dictionary select
    * options           1-9,A-Q           - dictionary options
  * text_field  glleng    60              - hidden translations
  * check_box  glonekoff  on              - no single-character matches
  * check_box  geolhonour on              - break on end of line
  * check_box  glduptr    on              - no repeated translations
  * check_box  glossonly  off             - only list translations
  * check_box  skipkata   off             - skip katakana words
  * check_box  skiphira   off             - skip hiragana words
  * check_box  skipname   off             - skip names
  * check_box  gasciiok   on              - skip names

_____________________
 Kanji lookup(GET ?1B)
   url POST ?1D
   TODO


_____________________
 Multiradical Kanji(GET ?1R)
   url POST ?1S
   TODO

_____________________
 Customization page(GET ?19B)
   url POST ?19A
   TODO

_____________________
 Example search(GET ?10)
  url POST ?11

_____________________
<pre>
