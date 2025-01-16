---
title: "Contact Us"
layout: page-sidebar
permalink: "/contact-us"
comments: false
---
<div id="comments" class="row mx-0 justify-content-center">
    <h5>여러분의 소중한 제보를 기다립니다. 제공해 주신 개인정보는 오직 취재를 위해서만 사용되며, 철저히 보호됩니다.</h5>


    <form id="comment-form" class="comment-form" autocomplete="off">
        <div class="form-row my-1">
            <div>
                <input type="text" class="form-control" id="title" placeholder="제목" required>
            </div>
        </div>
        <div class="form-group">
            <textarea class="form-control" id="note" rows="8" placeholder="내용" maxlength="2000" required></textarea>
            <div class="char-count"><span id="char-count">0</span> / 2000</div>
        </div>
        <div class="submit-container">
            <button type="button" class="submit-btn" id="generate-captcha-btn">Submit</button>
        </div>
        <div id="captcha-section" class="captcha-section">
            <div class="captcha-popup-content">
                <canvas id="captcha-canvas" width="140" height="37" class="captcha-canvas"></canvas>
                <input type="text" class="form-control" id="captcha-answer" placeholder="" required>
                <input type="hidden" id="captcha-id">
                <button type="button" class="submit-btn" id="verify-captcha-btn">Submit</button>
            </div>
        </div>
    </form>
</div>
<script type="text/javascript">
    const apiUrl = 'https://ep-core.mynews1237.workers.dev';
    const commentData = '190001021';

    const commentTextarea = document.getElementById('note');
    const charCountDisplay = document.getElementById('char-count');

    commentTextarea.addEventListener('input', () => {
        const currentLength = commentTextarea.value.length;
        if (currentLength > 2000) {
            commentTextarea.value = commentTextarea.value.slice(0, 2000);
        }
        charCountDisplay.textContent = currentLength;
    });
    
function getCurrentTextColor() {
    const rootElement = document.documentElement;
    const currentTheme = document.body.getAttribute('data-theme') || 'light';

    let color = '#000000';
    if('dark' == currentTheme){
        color = '#d0d0d0';
    }

    return color || 'black';
}

    // CAPTCHA 생성
    document.getElementById('generate-captcha-btn').addEventListener('click', async () => {
    const user_name = commentData;
    const comment = document.getElementById('note').value;
    const post_id = commentData;

    try {
        COMMON.showProgressBar();
        const response = await fetch(`${apiUrl}/generate-captcha`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ post_id, user_name, comment })
        });
        const data = await response.json();

        const canvas = document.getElementById('captcha-canvas');
        const context = canvas.getContext('2d');
        context.clearRect(0, 0, canvas.width, canvas.height);
        context.font = "20px Arial";
        context.fillStyle = getCurrentTextColor();
        context.textAlign = "center";
        context.textBaseline = "middle";

        const x = canvas.width / 2;
        const y = canvas.height / 2;
        // console.log('y',y)
        context.fillText(data.question, x, (y+2));

        document.getElementById('captcha-id').value = data.captchaId;
        
        document.getElementById('generate-captcha-btn').style.display = 'none';
        document.getElementById('captcha-section').classList.remove('d-none');
        document.getElementById('captcha-section').style.display = 'flex';
        showToast('noti','자동방지 문자를 입력하세요.');
        document.getElementById("captcha-answer").focus();
        
    } catch (error) {
        console.error('Detailed error:', error);
        showToast('alert','Error generating CAPTCHA. Please try again.');
    }
});

    // CAPTCHA 검증 및 문의하기 저장
    document.getElementById('verify-captcha-btn').addEventListener('click', async () => {
        const captchaAnswer = document.getElementById('captcha-answer').value;
        const captchaId = document.getElementById('captcha-id').value;
        const post_id = commentData;
        const title = document.getElementById('title').value;;
        const comment = document.getElementById('note').value;

        console.log(JSON.stringify({ post_id, title, comment, captchaId, captchaAnswer }));
        try {
            COMMON.showProgressBar();
            const response = await fetch(`${apiUrl}/contact_us`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ post_id, title, comment, captchaId, captchaAnswer })
            });
            console.log('response',response)
            console.log('response.ok',response.ok)
            if (response.ok) {
                showToast('noti','성공적으로 전송되었습니다.');
                // fetchComments();
                
                // 댓글 작성 폼과 CAPTCHA 초기화
                document.getElementById('comment-form').reset();
                document.getElementById('captcha-section').classList.add('d-none');
                document.getElementById('captcha-answer').value = "";
                document.getElementById('captcha-id').value = "";
                charCountDisplay.textContent = "0"; // 글자 수 초기화
            } else {
                showToast('alert','잘못된 CAPTCHA입니다. 다시 시도해주세요.');
                document.getElementById('captcha-answer').value = "";
                document.getElementById('captcha-id').value = "";
                document.getElementById('captcha-section').classList.add('d-none');
            }

            document.getElementById('generate-captcha-btn').style.display = 'block';
        } catch (error) {
            console.error('Error verifying CAPTCHA:', error);
            showToast('alert','Error verifying CAPTCHA. Please try again.');
            document.getElementById('generate-captcha-btn').style.display = 'block';
        }
    });
</script>