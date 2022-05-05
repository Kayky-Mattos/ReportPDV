*&---------------------------------------------------------------------*
*& Report Z_TA_03_REPORT_PDV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ta_03_report_pdv LINE-SIZE 110 NO STANDARD PAGE HEADING.

TABLES:zta03_cliente,
       zta03_produto,
       zta03_pedido,
       zta03_ped_pro.
*_______ PARAMETROS DE ENTRADA _______*

PARAMETERS: p_pedido TYPE zta03_pedido-id_pedido.

*_______ DECLARAÇÕES_______*

DATA: it_nome_prod TYPE znome_produto_t,
      wa_nome_prod TYPE znome_produto_st.

DATA: gt_pedido TYPE TABLE OF zta03_pedido,
      wa_pedido TYPE  zta03_pedido.



SELECT *
   FROM zta03_pedido
INTO TABLE gt_pedido
WHERE zta03_pedido~ID_pedido = p_PEDIDO .

IF sy-subrc EQ 0.

  SELECT
         id_produto
         nome_produto
   FROM zta03_produto
   INTO TABLE it_nome_prod
  FOR ALL ENTRIES IN gt_pedido
  WHERE id_produto = gt_pedido-id_produto.
    PERFORM apresenta_dados.
ELSE.
  MESSAGE ' O pedido inserido não existe ! ' TYPE 'I'.
ENDIF.








FORM apresenta_dados.
*--------- Apresenta o report(NF) ---------*
DATA: lv_sub_total TYPE ZVALORTOTAL.
WRITE: '       --------------------------------------------------------------------------------------------',/
       '                                   CUPOM FISCAL ELETRÔNICO - SAT                                   ',/
       '       --------------------------------------------------------------------------------------------',/ .
WRITE:  sy-uline,sy-vline,'Ped  ',
        sy-vline,'Cli',
        sy-vline,'Prod  ',
        sy-vline,'Nome.Produto        ',
        sy-vline,'itens ',
        sy-vline,'val total               ',
        sy-vline,'dat compra',
        sy-vline,'hora compra',sy-vline.
LOOP AT gt_pedido INTO wa_pedido.
  READ TABLE it_nome_prod ASSIGNING FIELD-SYMBOL(<lfs_nome_prod>) WITH KEY id_produto = wa_pedido-id_produto.
  MOVE <lfs_nome_prod>-nome_produto TO wa_nome_prod-nome_produto.

  IF sy-subrc EQ 0.
    WRITE:  sy-uline,/ sy-vline,wa_pedido-id_pedido,
             sy-vline,wa_pedido-id_cliente,
             sy-vline,wa_pedido-id_produto,
             sy-vline,wa_nome_prod-nome_produto(20),
             sy-vline,wa_pedido-quant_itens,
             sy-vline,wa_pedido-valor_total,
             sy-vline,wa_pedido-data,
             sy-vline,wa_pedido-hora,'  ',sy-vline.
    lv_sub_total = lv_sub_total + wa_pedido-valor_total.
  ENDIF.
ENDLOOP.
ULINE.
WRITE: sy-vline,'Sub Total:', lv_sub_total,'                                                                      ',sy-vline,sy-uline.
ENDFORM.