const express = require('express');  
const app = express();  
const PORT = process.env.PORT || 80;  

app.get('/', (req, res) => {  
  res.send('Hello, DevOps World!');  
});  

app.listen(PORT, () => {  
  console.log(`Server is running on port ${PORT}`);  
});