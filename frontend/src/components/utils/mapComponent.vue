<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta
      name="viewport"
      content="initial-scale=1.0, user-scalable=no, width=device-width"
    />
    <title>HELLO，AMAP!</title>
    <style>
      html,
      body,
      #container {
        width: 100%;
        height: 100%;
      }
    </style>
  </head>
  <body>
    <div id="container"></div>
  </body>
</html>

<script type="text/javascript">
  window._AMapSecurityConfig = {
    securityJsCode: "「你申请的安全密钥」",
  };
</script>
<script src="https://webapi.amap.com/loader.js"></script>
<script type="text/javascript">
  AMapLoader.load({
    key: "	9033ff8c79a0d8af4aa42d89204e9590", //申请好的Web端开发者 Key，调用 load 时必填
    version: "2.0", //指定要加载的 JS API 的版本，缺省时默认为 1.4.15
  })
    .then((AMap) => {
      const map = new AMap.Map("container");
    })
    .catch((e) => {
      console.error(e); //加载错误提示
    });
</script>

