// pull in desired CSS/SASS files
// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if Bootstrap's JS not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' ); // <--- remove if Bootstrap's JS not needed 

$("#root").click(function() {
    console.log("Root");
    $("#main").html("");
    $("#text").show();
});

$("#1_0").click(function() {
    // inject bundled Elm app into div#main
    $("#main").html("");
    var Elm = require( '../elm/1.0/Main' );
    Elm.Main.embed( document.getElementById( 'main' ) );    
    $("#text").hide();
});
