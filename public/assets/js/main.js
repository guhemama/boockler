$(document).ready(function() {
  "use strict";
  
  // Hides alerts on click
  $('.alert').click(function() {
    $(this).slideUp(200);
  });
  
  // Delete a book upon confirmation
  $('.book-delete').click(function() {
    var conf = confirm("Are you sure you want to delete this book?");
    
    if (conf === true) {
      var url = $(this).data('url');
      $.post(url, { _method: 'delete' }, function() {      
        window.location = '/';
      });
    }
  });
});
