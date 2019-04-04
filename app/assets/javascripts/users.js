document.addEventListener('turbolinks:load', function() {
  $('#user_avatar').bind('change', function() {
    // プロフィール画像サイズのバリデーション
    if(this.files && this.files[0]) {
      let size_in_megabytes = this.files[0].size/1024/1024;
      if (size_in_megabytes > 5) {
        alert('画像は５MB以下のものにしてください');
      }
    }

    // プロフィール画像のプレビュー
    function readURL(input) {
      if (input.files && input.files[0]) {
        let reader = new FileReader();
  
        reader.onload = function (e) {
          $('#avatar-img-prev').attr('src', e.target.result);
        };
        reader.readAsDataURL(input.files[0]);
      }
    }

    if (this.files && this.files[0]) {
      $('#avatar-img-prev').removeClass('d-none');
      $('.avatar-present-img').addClass('d-none');
      readURL(this);
    } else { // キャンセルされてinputが空になったとき
      $('#avatar-img-prev').addClass('d-none');
      $('.avatar-present-img').removeClass('d-none');
    }
  });
});
