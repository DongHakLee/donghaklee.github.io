var COMMON = (function() {
    var alertOverlay, promptOverlay, toast, progressBar;
    var toastTimeout;
    var promptCallback;

    // 페이지 로드 시 필요한 요소 생성
    document.addEventListener('DOMContentLoaded', function() {
        // Progress Bar 생성
        progressBar = document.createElement('div');
        progressBar.id = 'commonProgressBar';
        progressBar.innerHTML = '<div class="spinner"></div>';
        progressBar.style.display = 'none';
        document.body.appendChild(progressBar);

        // Toast 생성
        toast = document.createElement('div');
        toast.id = 'commonToast';
        document.body.appendChild(toast);

        // Alert 모달 생성
        alertOverlay = document.createElement('div');
        alertOverlay.className = 'common-modal-overlay';
        alertOverlay.innerHTML = `
            <div class="common-modal">
                <h2>알림</h2>
                <p id="alertMessage"></p>
                <button onclick="COMMON.closeAlert()">확인</button>
            </div>`;
        document.body.appendChild(alertOverlay);

        // Prompt 모달 생성
        promptOverlay = document.createElement('div');
        promptOverlay.className = 'common-modal-overlay';
        promptOverlay.innerHTML = `
            <div class="common-modal">
                <h2>입력 요청</h2>
                <p id="promptMessage"></p>
                <input type="text" id="promptInput" />
                <button onclick="COMMON.submitPrompt()">확인</button>
                <button class="secondary" onclick="COMMON.closePrompt()">취소</button>
            </div>`;
        document.body.appendChild(promptOverlay);
    });

    return {
        showProgressBar: function() {
            progressBar.style.display = 'flex';
        },
        hideProgressBar: function() {
            progressBar.style.display = 'none';
        },
        showToast: function(type, message, duration) {
            // 타입에 따라 색상 변경
            if (type === 'alert') {
                toast.classList.add('alert');
                toast.classList.remove('notification');
            } else {
                toast.classList.add('notification');
                toast.classList.remove('alert');
            }
        
            toast.textContent = message;
            toast.classList.add('show');
        
            // Progress Bar도 같이 사라지게 설정
            function hideProgressBarIfVisible() {
                if (progressBar && progressBar.style.display === 'flex') {
                    progressBar.style.display = 'none';
                }
            }
            hideProgressBarIfVisible(); // Toast가 사라질 때 Progress Bar도 숨김
        
            if (toastTimeout) clearTimeout(toastTimeout);
            toastTimeout = setTimeout(function() {
                toast.classList.remove('show');
            }, duration || 2000);
        },
        customAlert: function(message) {
            document.getElementById('alertMessage').textContent = message;
            alertOverlay.style.display = 'flex';
        },
        closeAlert: function() {
            alertOverlay.style.display = 'none';
        },
        customPrompt: function(message, callback) {
            promptCallback = callback;
            document.getElementById('promptMessage').textContent = message;
            document.getElementById('promptInput').value = '';
            promptOverlay.style.display = 'flex';
        },
        closePrompt: function() {
            promptOverlay.style.display = 'none';
        },
        submitPrompt: function() {
            var input = document.getElementById('promptInput').value;
            promptOverlay.style.display = 'none';
            if (promptCallback) promptCallback(input);
        }
    };
})();
