<?php declare(strict_types=1);

/**
 * Einrichtungshaus Ostermann GmbH & Co. KG - Article Data Sheet
 *
 * @package   OstArticleDataSheet
 *
 * @author    Eike Brandt-Warneke <e.brandt-warneke@ostermann.de>
 * @copyright 2019 Einrichtungshaus Ostermann GmbH & Co. KG
 * @license   proprietary
 */

use Shopware\Bundle\StoreFrontBundle\Service\ProductServiceInterface;
use Shopware\Components\CSRFWhitelistAware;
use Mpdf\Mpdf;

class Shopware_Controllers_Frontend_OstArticleDataSheet extends Enlight_Controller_Action implements CSRFWhitelistAware
{
    /**
     * ...
     *
     * @return array
     */
    public function getWhitelistedCSRFActions()
    {
        // return all actions
        return array_values(array_filter(
            array_map(
                function ($method) { return (substr($method, -6) === 'Action') ? substr($method, 0, -6) : null; },
                get_class_methods($this)
            ),
            function ($method) { return  !in_array((string) $method, ['', 'index', 'load', 'extends'], true); }
        ));
    }

    /**
     * ...
     *
     * @throws Exception
     */
    public function preDispatch()
    {
        // ...
        $viewDir = $this->container->getParameter('ost_article_data_sheet.view_dir');
        $this->get('template')->addTemplateDir($viewDir);
        parent::preDispatch();
    }

    /**
     * ...
     */
    public function indexAction()
    {
        // get the article number
        $number = $this->Request()->getParam("number");

        /** @var ProductServiceInterface $product */
        $productService = Shopware()->Container()->get("shopware_storefront.product_service");

        // get the product
        $product = $productService->get(
            $number,
            Shopware()->Container()->get("shopware_storefront.context_service")->getShopContext()
        );

        // assign our product
        $this->View()->assign('product', $product);

        // get the html for the pdf
        $html = $this->View()->fetch('frontend/ost-article-data-sheet/data-sheet.tpl');



        // create mpdf
        $mpdf = new Mpdf(array_replace_recursive(
            Shopware()->Container()->getParameter('shopware.mpdf.defaultConfig'),
            [
                'mirrorMargins' => 0,
                'showImageErrors' => false,
                'debug' => false,
                'defaultheaderfontsize' => 10,
                'defaultheaderfontstyle' => 'B',
                'defaultheaderline' => 1,
            ]
        ));

        // set header
        $mpdf->SetHeader('{DATE j.m.Y}|{PAGENO}|' . $number);

        // set it as html
        $mpdf->WriteHTML($html);

        // output
        $mpdf->Output('Datenblatt_' . $number . '.pdf', 'I');

        // and stop
        die();
    }
}
