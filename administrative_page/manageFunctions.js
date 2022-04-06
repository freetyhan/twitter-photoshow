function changeBackground() {
    let color = document.getElementById('colorInputColor').value;
    document.getElementById('imageBackground').style.backgroundColor = color;
};

function displayOptions() {
    var chb1 = document.getElementById('formCheck-1');
    var chb2 = document.getElementById('formCheck-2');
    var chb3 = document.getElementById('formCheck-3');
    var chb4 = document.getElementById('formCheck-4');
    
    if(chb1.checked) {
        document.getElementById('twitter-name').style.display = 'block';
    }
    if(!chb1.checked) {
        document.getElementById('twitter-name').style.display = 'none';
    }

    if(chb2.checked){
        document.getElementById('twitter-username').style.display = 'block';
    } 
    if(!chb2.checked) {
        document.getElementById('twitter-username').style.display = 'none';
    }

    if(chb3.checked) {
        document.getElementById('twitter-caption').style.display = 'block';
    }
    if(!chb3.checked) {
        document.getElementById('twitter-caption').style.display = 'none';
    }

    if(chb4.checked) {
        document.getElementById('dish-name').style.display = 'block';
    }
    if(!chb4.checked) {
        document.getElementById('dish-name').style.display = 'none';
    }
};

function transitions() {
    var option = document.getElementById("mySelect").value;
    var testimg = document.getElementById("testimg");
    var imageBackground = document.getElementById("imageBackground");
    var textover = document.getElementById("textover");
    if (option == 1) { // random
        testimg.style.opacity = 1;
        imageBackground.style.opacity = 1;
        textover.style.opacity = 0.6;
    }
    if (option == 2) { // fade
        unfade(testimg);
        unfade(imageBackground);
        unfadeText(textover);
    }
    if (option == 3) { // panning
        var blackCover = document.getElementById("blackCover");
        blackCover.style.visibility = "visible";
        cover(blackCover);
    }
};

function unfade(element) {
    var op = 0.1;  // initial opacity
    var timer = setInterval(function () {
        if (op >= 1){
            clearInterval(timer);
        }
        element.style.opacity = op;
        op += op * 0.1;
    }, 50); // interval set to 50
};

function unfadeText(element) {
    var op = 0.1;  // initial opacity
    var timer = setInterval(function () {
        if (op >= 0.6){
            clearInterval(timer);
        }
        element.style.opacity = op;
        op += op * 0.1;
    }, 50); // interval set to 50
};

function cover(element) {
    var width = 904;  // initial width
    var timer = setInterval(function () {
        if (width <= 0){
            clearInterval(timer);
            element.style.visibility = 'hidden';
        }
        width -= 10;
        element.style.width = width + 'px';
    }, 25);
};