<?php declare(strict_types=1);
require __DIR__ . '/../../../../../vendor/autoload.php';

$loader = new \Composer\Autoload\ClassLoader();
$loader->addPsr4('OstArticleDataSheet\\', __DIR__ . '/../../');

$loader->register();
