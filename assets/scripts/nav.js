$(function() {
    let $body = $("body")
    let $nav = $body.children("nav");
    let $hamburger = $nav.find(".hamburger");

    let $fullsize_nav = $("#fullsize_nav");
    let $cancel = $fullsize_nav.find(".cancel");

    $hamburger.on("click", () => {
        $body.addClass("menu");
    });
    $cancel.on("click", () => {
        $body.removeClass("menu");
    });
});