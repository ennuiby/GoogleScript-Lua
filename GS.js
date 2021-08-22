function doGet(e) {
    try {
      var ss = SpreadsheetApp.getActiveSpreadsheet();
  
      var data = e.parameter;
      var response = {};
  
      if(data.method == undefined){
        response.statusCode = 400;
        response.statusMessage = 'Bad request'
        return ContentService.createTextOutput(JSON.stringify(response));    
      }
      if (data.method == 'chatlog'){
        var chatlog = ss.getSheetByName('Чатлог');
        var text = JSON.parse(data.data);
        var nick = data.nick;
        var date = data.date;
        if (data.data) {
          response.statusCode = 200;
          response.statusMessage = 'OK';
          chatlog.appendRow([nick, text.text, date]);
          return ContentService.createTextOutput(JSON.stringify(response));
        } else {
          response.statusCode = 400;
          response.statusMessage = 'Bad request'
          return ContentService.createTextOutput(JSON.stringify(response));    
        }
      } else if (data.method == 'something') { //some function
        //
        //
        //
        //
      } else { // if method is undefined
        response.statusCode = 405;
        response.statusMessage = 'Method Not Allowed'
        return ContentService.createTextOutput(JSON.stringify(response));   
      }
    } catch(e) {
      return ContentService.createTextOutput(e);
    }
  }