$(document).ready(function(){
    var lastClickedId = null;

    $(document).on('click', '.mailPost', function(){
        var clickedId = $(this).attr('id');
        fetch(`https://${GetParentResourceName()}/getPostData`, { method: 'POST', headers: {'Content-Type': 'application/json; charset=UTF-8'}, body: JSON.stringify({ post_id: clickedId }) });

        if(clickedId === lastClickedId) {
            $('.postBoxLeft').remove();
            lastClickedId = null;
        } else {
            $('.postBoxLeft').remove();
            var $postBoxLeft = $(`
                <div class="postBoxLeft">
                    <div class="postBoxHeader">받은 우편</div>
                    <div class="postTitleBox">
                        <span class="title">보낸 사람 : 치즈 운영팀</span>
                        <span class="title" id="postTitleBoxTitle">제목 : 불러오는 중...</span>
                    </div>
                    <div class="postContentBox">
                        <span class="content">
                            <span id="postContentBoxText">불러오는 중...</span>
                            <br></br>
                            <br></br>
                            <span class="itemRewardTitle">받은 아이템</span>
                        </span>
                    </div>
                    <div class="buttonPostion">
                        <button class="itemRewardButton" onclick="itemReward(${clickedId})">보상 수령</button>
                        <button class="itemRewardClose">닫기</button>
                    </div>
                </div>
            `);
            $('body').append($postBoxLeft);
            lastClickedId = clickedId;
        }
    });

    $(document).keyup(function (e) {
        if (e.keyCode == 27) {
            $(".mailPost").remove();
            $('.postBoxLeft').remove();
            $('.postBoxLeft').hide();
            $(".postBox").hide();
            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: {'Content-Type': 'application/json; charset=UTF-8'},
            });
        }
    });
});

function itemReward(post_id) {
    fetch(`https://${GetParentResourceName()}/itemReward`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: JSON.stringify({ post_id: post_id })
    }).then(() => {
        deleteMailBox(post_id);
        if ($('.mailPost').length === 0) {
            $(".warningNotify").show();
        }
    });
}

function deleteMailBox(post_id) {
    $('#' + post_id).remove();
    $('.postBoxLeft').remove();
}

function noImage() {
    $("img").attr("src", "./static/images/logo.png");  
}

window.addEventListener('message', function (event) {
    const data = event.data;
    if (data.type == "open") {
        if (data.postData == null) {
            $(".postBox").show();
            $(".warningNotify").show();
            $(".userInfoText").text(`${data.userName} 님의 우편`)
        } else {
            const postContainer = document.querySelector('.postBox');
            (data.postData).forEach(post => {
                const postHTML = `
                    <div class="mailPost" id="${post.post_id}">
                        <div class="imageBox">
                            <img src="./static/images/logo.png" />
                        </div>
                        <div class="textContents">
                            <span class="title">${JSON.parse(post.post_data).title}</span>
                            <span class="description">${JSON.parse(post.post_data).subTitle}</span>
                        </div>
                    </div>
                `;
                postContainer.innerHTML += postHTML;
            });
            $(".userInfoText").text(`${data.userName}(${data.user_id}) 님의 우편`)
            $(".warningNotify").hide();
            $(".postBox").show();
        }
    } else if (data.type == "openModal") {
        $("#postTitleBoxTitle").text(`제목 : ${JSON.parse(data.postData).title}`)
        $("#postContentBoxText").html(`${JSON.parse(data.postData).description}`)
        const postContainer = document.querySelector('.content');
        (JSON.parse(data.postData).itemList).forEach(post => {
            const postHTML = `
                <div class="itemRewardBox">
                    <div class="itemInfo">
                        <img class="itemImage" src="./static/images/${post.itemImage}.png" onerror="noImage()" />
                        <span class="itemName">${post.itemName}</span>
                    </div>
                    <span class="itemCount">${post.itemAmount}</span>
                </div>
            `;
            postContainer.innerHTML += postHTML;
        });
    } else if (data.type == "deleteMailBox") {
        deleteMailBox(data.post_id)
    }
});