<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<title>Security Question</title>
<meta charset="UTF-8">
<link rel="stylesheet" href="../cactus/vendor/css/bootstrap.min.css" />
<link rel="stylesheet" href="../cactus/assets/css/app.css" />
<script src="../cactus/vendor/js/jquery-2.0.3.min.js"></script>
<script src="../cactus/vendor/js/jquery.validate.min.js"></script>
</head>
<body class="background">

<div>
<section class="main">
	<form:form action="verifySecurityQuestion" method="post" class="form-2"
		name="userProfile" commandName="userProfile" modelAttribute="userProfile">
		<form:errors path="errorMsg" cssStyle="color: #ff0000;"/>
		
		<h1><span class="log-in">Security Question</span><span class="sign-up">${status.count}</span></h1>
		<c:forEach items="${userProfile.securityQnAList}" var="qna" varStatus="status">
        <p class="">
		<input type="hidden" id="securityQnAList${status.index}.question" name="securityQnAList[${status.index}].question" value="${qna.question}"/>
            <label for="login"><i class="icon-user"></i>${qna.question}?</label>
           <input type="text" id="securityQnAList${status.index}.answer" name="securityQnAList[${status.index}].answer" autocomplete="off" value="" required/>
        </p>
		 </c:forEach>
		 <input class="clearfix" style="float:none;" type="submit" value="Submit">
		</form:form>
	
</section>
</div>
</body>
</html>