$(document).on('turbolinks:load', function() {
  $("#preview_button, #clip_preview_button").click(function() {

    var url = $("#clip_url").val();

    var urlRegex = /\A.*clip.*twitch\.tv.*\z/;

    if (!url.match(urlRegex)) {
      var errorMessage = "クリップが見つからないヨ";
      var flashMessage = $("<div class='alert alert-danger font-6'>" + errorMessage + "</div>");
      $("#flash_messages").html(flashMessage); 
      return false;
    }

    var clip_post = {
      clip_post: {
        url: url,
        content_title: $("#content_title").val(),
        tag_list: $("#tag_list").val(),
        streamer_list: $("#streamer_list").val(),
      }
    }

    $.ajax({
        url: "/clip_posts/get_clip",
        method: "GET",
        data: clip_post
    })
  })
})