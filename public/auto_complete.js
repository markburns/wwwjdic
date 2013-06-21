$(document).ready(

    function(){
      $('#suggestions').hide();
      ich.grabTemplates();
      var getSuggestions = function(value){

        if(value.length > 0){
          $.getJSON('/auto-complete', {auto_complete: value},  function(data) {
            $('#suggestions').html('');
            if(data.length > 0){

              $.each(data, function(index, word) {
                var link = ich.suggestion_template({suggestion_text: word});
                $('#suggestions').append(link);
              });
              $('#suggestions').show();
            }
          });
        }
        else{

          $('#suggestions').hide();
        }

      };


      $('#query').bind(
          'keyup',

          function(){
            // Only fire change if value has changed
            var value = this.value;

            if((this).value.length === 0){
              $('#suggestions').hide();
            }
            if(value != this.lastValue) {
              this.lastValue = value;
              if(timeout) {
                clearTimeout(timeout);
              }
              else{
                var timeout = setTimeout(function() {
                  // Process....
                  getSuggestions(value);
                }, 1000);
              }
            }
          }
      );
    }
);
