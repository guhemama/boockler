<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);


function readBooksFromFile($status)
{
    $books = array_values(
               array_filter(
                 explode("\n",
                   file_get_contents("storage/{$status}.txt")), 'trim'));    
    sort($books);    
    return $books;
}

function printBooks($status)
{
    foreach (readBooksFromFile($status) as $book)
    {
        echo "<li>{$book}</li>";
    }
}

?>

<!doctype html>
<head>
	<meta charset="utf-8">
	<title>My Personal Library</title>
	<link rel="stylesheet" href="styles.css">
	<link href='http://fonts.googleapis.com/css?family=Gabriela' rel='stylesheet' type='text/css'>
</head>

<body>
    <div id="content">
        <h1>My Personal Library</h1>

        <h2>Reading</h2>
        <ul>
            <? printBooks('reading') ?>
        </ul>

        <h2>Unread</h2>
        <ul>
            <? printBooks('unread') ?>            
        </ul>

        <h2>Read</h2>
        <ul>
            <? printBooks('read') ?>            
        </ul>
    </div>
</body>
</html>

