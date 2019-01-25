$('#q').autocomplete({
  source: function (request, response) {
    $.ajax({
      url: "/autocomplete/items", // should be with '/'
      dataType: 'json',
      data: { query: request.term },
      success: function(data) {
        // call response to return the result to autocomplete box
        response(data);
      }
    });
  }
});