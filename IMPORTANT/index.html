<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>RNG GUI</title>
  <style>
    html,body{
      height:100%;
      margin:0;
      font-family: "Source Sans Pro", "Segoe UI", Roboto, Arial, sans-serif;
      background: #111;
      color: #fff;
      display:flex;
      align-items:center;
      justify-content:center;
    }

    .container{
      text-align:center;
    }

    .label {
      width: 400px;
      height: 100px;
      display:flex;
      align-items:center;
      justify-content:center;
      margin: 0 auto 14px auto;
      background: rgba(0,0,0,0.55);
      border-radius: 8px;
      font-weight:700;
      font-size: clamp(18px, 3.5vw, 28px);
      box-shadow: 0 6px 18px rgba(0,0,0,0.6), inset 0 1px 0 rgba(255,255,255,0.02);
      user-select: none;
    }

    .sub {
      font-size: 13px;
      opacity: 0.8;
      margin-top: 6px;
    }

    button {
      padding: 8px 14px;
      border-radius: 8px;
      border: 0;
      background: #2e8bff;
      color: #fff;
      font-weight:600;
      cursor:pointer;
    }

    button:active { transform: translateY(1px); }
    .picked {
      margin-top: 10px;
      font-size: 13px;
      opacity: 0.9;
      color: #ddd;
    }
  </style>
</head>
<body>
  <div class="container">
    <div id="label" class="label">...</div>
    <div>
      <button id="rollBtn">Roll</button>
    </div>
    <div id="picked" class="picked" aria-live="polite"></div>
    <div class="sub">Target: <code>tttttttttttttg</code></div>
  </div>

  <script>
    // The table of strings (keeps same entries as your Lua)
    const strings = [
      "tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttg",
      "tttttttttttttg",  // target string
      "No!",
      "Yes!",
      "Yesn't",
      "Maybe...",
      "Probably not",
      "Absolutely!",
      "Hmm...",
      "Try again later",
      "Error: undefined",
      "Success!",
      "Loading...",
      "Done!",
      "Wait—what?"
    ];

    const TARGET = "tttttttttttttg";

    // Secure random integer in [0, max-1]
    function randomIndex(max) {
      // Use crypto if available for better randomness
      if (window.crypto && window.crypto.getRandomValues) {
        const range = max;
        const array = new Uint32Array(1);
        window.crypto.getRandomValues(array);
        return array[0] % range;
      } else {
        return Math.floor(Math.random() * max);
      }
    }

    const labelEl = document.getElementById('label');
    const pickedEl = document.getElementById('picked');
    const rollBtn = document.getElementById('rollBtn');

    function rollOnce(showPicked = true) {
      const idx = randomIndex(strings.length);
      const picked = strings[idx];

      if (picked === TARGET) {
        labelEl.textContent = "🎯 RNG hit! The target string was picked!";
      } else {
        labelEl.textContent = "❌ RNG missed. Nothing happens.";
      }

      // Optionally show which string was picked (helpful for debugging)
      if (showPicked) {
        pickedEl.textContent = 'Picked string: "' + picked + '" (index ' + (idx+1) + ')';
      }
    }

    // Run once on load
    rollOnce();

    // Allow reroll
    rollBtn.addEventListener('click', () => rollOnce());
  </script>
</body>
</html>
