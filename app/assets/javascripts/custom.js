document.addEventListener('turbolinks:load',function(){
  $('#test').click(function() {
    $('#norm-description').hide();
    $('#norm-input').show();
  });
});
