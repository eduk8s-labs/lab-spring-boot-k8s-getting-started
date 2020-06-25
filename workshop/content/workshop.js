console.log("Script about to be loaded");
$(document).ready(function() {
    console.log("Appluing click hanlder to elements");
    $.each([$("a.ide-link")], function() {
        this.parent().click(function(event) {
            console.log("Click being handled");
            event.preventDefault();
            var text = $(event.target).contents().text();
            var link = event.target.getAttribute("href");
            console.log("Clicked link: link=" + link + " text=" + text);

            console.log("Sending to Editor");
            parent.send_to_editor();
        });
    });

});