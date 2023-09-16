$(document).on('turbolinks:load', function() {
  $("#preview_button, #clip_preview_button").click(function() {
    var clip_post = {
      clip_post: {
        url: $("#clip_url").val(),
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