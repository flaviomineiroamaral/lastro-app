-- ==============================================================================
-- MIGRAÇÃO DE SINCRONIZAÇÃO: HOMOLOGAÇÃO -> PRODUÇÃO
-- Data de Geração: 2026-10-14
-- Objetivo: Sincronizar com total segurança (zero perda de dados e retrocompatibilidade)
-- ==============================================================================

-- 1. ESTRUTURA DE TABELAS (COLUNAS ADICIONAIS SEGURAS)
ALTER TABLE public.assinaturas_b2c ADD COLUMN IF NOT EXISTS codigo_parceria text;
ALTER TABLE public.assinaturas_b2c ADD COLUMN IF NOT EXISTS codigo_parceria_status text;
ALTER TABLE public.assinaturas_b2c ADD COLUMN IF NOT EXISTS organization_id uuid;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assinaturas_b2c_organization_id_fkey') THEN
        ALTER TABLE ONLY public.assinaturas_b2c
            ADD CONSTRAINT assinaturas_b2c_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);
    END IF;
END $$;

ALTER TABLE public.contratos_b2b ADD COLUMN IF NOT EXISTS plano_id integer;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'contratos_b2b_plano_id_fkey') THEN
        ALTER TABLE ONLY public.contratos_b2b
            ADD CONSTRAINT contratos_b2b_plano_id_fkey FOREIGN KEY (plano_id) REFERENCES public.planos_comerciais(id) ON DELETE RESTRICT;
    END IF;
END $$;

-- 2. VIEWS OTIMIZADAS
CREATE OR REPLACE VIEW "public"."view_membros_equipe" WITH ("security_invoker"='true') AS
 SELECT "om"."id" AS "vinculo_id",
    "om"."organization_id",
    "o"."nome" AS "nome_organizacao",
    COALESCE("o"."razao_social_oficial", "cb"."razao_social", "o"."nome") AS "razao_social_oficial",
    COALESCE("o"."documento_cnpj", "cb"."cnpj", "ac"."cpf") AS "documento_cnpj",
    "o"."ativo" AS "organizacao_ativa",
    "om"."profile_id",
    "p"."nome_completo" AS "nome_utilizador",
    "p"."email",
    "om"."funcao",
    "o"."tipo" AS "tipo_organizacao",
    COALESCE("pc"."nome", "o"."plano", "cb"."nome_plano", 'Plano Padrão'::"text") AS "plano_organizacao",
    COALESCE("pc"."limite_crs", "o"."limite_crs_atual", 1) AS "limite_crs_plano",
    COALESCE("o"."limite_crs_atual", "pc"."limite_crs", 1) AS "limite_crs_atual",
        CASE
            WHEN ((COALESCE("pc"."valor_mensal", (0)::numeric) = (0)::numeric) OR ("pc"."nome" ~~* '%gratuito%'::"text") OR ("o"."plano" ~~* '%gratuito%'::"text")) THEN true
            ELSE false
        END AS "is_plano_gratuito",
    "cb"."status_pagamento_setup",
        CASE
            WHEN ("cb"."status_pagamento_setup" = 'expirado'::"text") THEN true
            ELSE false
        END AS "is_inadimplente_setup",
    "cb"."id" AS "contrato_id",
    "cb"."link_boleto_setup",
    "ab"."id" AS "assinatura_b2b_id",
    "ab"."link_pagamento" AS "link_mensalidade_b2b",
    "ab"."status_assinatura" AS "status_assinatura_b2b",
    "ac"."status_assinatura" AS "status_assinatura_b2c",
        CASE
            WHEN ("o"."ativo" = false) THEN true
            WHEN ("o"."tipo" = 'Família'::"text") THEN
            CASE
                WHEN ("ac"."status_assinatura" = ANY (ARRAY['atrasada'::"text", 'cancelada'::"text", 'pendente'::"text"])) THEN true
                ELSE false
            END
            ELSE
            CASE
                WHEN ("cb"."status_pagamento_setup" = 'expirado'::"text") THEN true
                WHEN ("ab"."status_assinatura" = ANY (ARRAY['atrasada'::"text", 'cancelada'::"text"])) THEN true
                ELSE false
            END
        END AS "is_bloqueado_financeiro"
   FROM (((((("public"."organization_members" "om"
     JOIN "public"."profiles" "p" ON (("om"."profile_id" = "p"."id")))
     JOIN "public"."organizations" "o" ON (("om"."organization_id" = "o"."id")))
     LEFT JOIN LATERAL ( SELECT "ab_sub"."id",
            "ab_sub"."contrato_id",
            "ab_sub"."plano_id",
            "ab_sub"."link_pagamento",
            "ab_sub"."status_assinatura",
            "ab_sub"."valor_mensal"
           FROM "public"."assinaturas_b2b" "ab_sub"
          WHERE ("ab_sub"."organization_id" = "o"."id")
          ORDER BY
                CASE
                    WHEN ("ab_sub"."status_assinatura" = 'ativa'::"text") THEN 1
                    WHEN ("ab_sub"."status_assinatura" = 'pendente'::"text") THEN 2
                    WHEN ("ab_sub"."status_assinatura" = 'atrasada'::"text") THEN 3
                    ELSE 4
                END, "ab_sub"."created_at" DESC
         LIMIT 1) "ab" ON (true))
     LEFT JOIN LATERAL ( SELECT "cb_sub"."id",
            "cb_sub"."status_pagamento_setup",
            "cb_sub"."link_boleto_setup",
            "cb_sub"."razao_social",
            "cb_sub"."cnpj",
            "cb_sub"."nome_plano"
           FROM "public"."contratos_b2b" "cb_sub"
          WHERE (("cb_sub"."organization_id" = "o"."id") OR ("cb_sub"."id" = "ab"."contrato_id") OR (("o"."documento_cnpj" IS NOT NULL) AND ("cb_sub"."cnpj" = "o"."documento_cnpj")) OR ("cb_sub"."user_id" = "o"."owner_id"))
          ORDER BY "cb_sub"."created_at" DESC
         LIMIT 1) "cb" ON (true))
     LEFT JOIN LATERAL ( SELECT "ac_sub"."id",
            "ac_sub"."plano_id",
            "ac_sub"."status_assinatura",
            "ac_sub"."cpf",
            "ac_sub"."valor_mensal"
           FROM "public"."assinaturas_b2c" "ac_sub"
          WHERE (("ac_sub"."user_id" = "p"."id") OR ("ac_sub"."user_id" = "o"."owner_id") OR (("o"."documento_cnpj" IS NOT NULL) AND ("ac_sub"."cpf" = "o"."documento_cnpj")) OR (("p"."email" IS NOT NULL) AND ("ac_sub"."email" = "p"."email")))
          ORDER BY
                CASE
                    WHEN ("ac_sub"."status_assinatura" = 'ativa'::"text") THEN 1
                    WHEN ("ac_sub"."status_assinatura" = 'pendente'::"text") THEN 2
                    WHEN ("ac_sub"."status_assinatura" = 'atrasada'::"text") THEN 3
                    ELSE 4
                END, "ac_sub"."created_at" DESC
         LIMIT 1) "ac" ON (true))
     LEFT JOIN "public"."planos_comerciais" "pc" ON (("pc"."id" = COALESCE("o"."plano_id", "ab"."plano_id", "ac"."plano_id"))));;

-- 3. FUNÇÕES E REGRAS DE NEGÓCIO ATUALIZADAS
CREATE OR REPLACE FUNCTION "public"."create_my_organization"("org_name" "text", "org_type" "text", "p_user_id" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  new_org_id UUID;
BEGIN
  -- 1. Cria a Organização (AGORA COM O OWNER_ID)
  INSERT INTO public.organizations (nome, tipo, owner_id)
  VALUES (org_name, org_type, p_user_id)
  RETURNING id INTO new_org_id;

  -- 2. Vincula o usuário passado pelo FlutterFlow como DONO
  INSERT INTO public.organization_members (organization_id, profile_id, funcao)
  VALUES (new_org_id, p_user_id, 'Dono');

  -- 3. Retorna o pacote completo em JSON
  RETURN json_build_object(
      'currentOrganizationId', new_org_id,
      'currentOrganizationType', org_type,
      'currentOrganizationName', org_name,
      'currentUser', p_user_id,
      'currentFunction', 'Dono',
      'currentPlanName', 'Gratuito'
  );
END;$$;

CREATE OR REPLACE FUNCTION "public"."validar_serial"("p_serial_ativacao" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    v_resultado json;
    v_uuid uuid;
    v_reg record;
    v_arr text[];
    v_nome_formatado text;
    v_nome_org text; -- Nova variável para guardar o nome da organização
BEGIN
    -- 1. CONVERSÃO SEGURA PARA UUID
    BEGIN
        v_uuid := p_serial_ativacao::uuid;
    EXCEPTION WHEN invalid_text_representation THEN
        RETURN json_build_object(
            'valido', false, 
            'serial_utilizado', false, 
            'mensagem', 'Formato inválido. O código não é um UUID.'
        );
    END;

    -- 2. PESQUISA B2B (Corporativo)
    SELECT * INTO v_reg FROM public.contratos_b2b WHERE serial_ativacao = v_uuid LIMIT 1;
    
    IF FOUND THEN
        IF v_reg.responsavel IS NULL OR trim(v_reg.responsavel) = '' THEN
            v_nome_formatado := '';
        ELSE
            v_arr := string_to_array(regexp_replace(trim(v_reg.responsavel), '\s+', ' ', 'g'), ' ');
            
            IF array_length(v_arr, 1) > 1 THEN
                v_nome_formatado := v_arr[1] || ' ' || v_arr[array_length(v_arr, 1)];
            ELSE
                v_nome_formatado := v_arr[1];
            END IF;
        END IF;

        RETURN json_build_object(
            'valido', true,
            'id_registro', v_reg.id,
            'razao_social', v_reg.razao_social, 
            'nome_completo', v_nome_formatado,
            'email', v_reg.email,
            'tipo_perfil', v_reg.tipo_perfil,
            'serial_utilizado', v_reg.serial_utilizado,
            'tabela_origem', 'contratos_b2b'
        );
    END IF;

    -- 3. PESQUISA B2C (Uso Pessoal / Famílias)
    SELECT * INTO v_reg FROM public.assinaturas_b2c WHERE serial_ativacao = v_uuid LIMIT 1;
    
    IF FOUND THEN
        IF v_reg.nome_completo IS NULL OR trim(v_reg.nome_completo) = '' THEN
            v_nome_formatado := '';
            v_nome_org := 'Família';
        ELSE
            v_arr := string_to_array(regexp_replace(trim(v_reg.nome_completo), '\s+', ' ', 'g'), ' ');
            
            -- Cria o nome da organização B2C dinamicamente usando o primeiro nome
            v_nome_org := 'Pessoal ' || v_arr[1];
            
            IF array_length(v_arr, 1) > 1 THEN
                v_nome_formatado := v_arr[1] || ' ' || v_arr[array_length(v_arr, 1)];
            ELSE
                v_nome_formatado := v_arr[1];
            END IF;
        END IF;

        RETURN json_build_object(
            'valido', true,
            'id_registro', v_reg.id,
            'razao_social', v_nome_org,            -- AGORA DEVOLVE "Pessoal Flávio" EM VEZ DE NULL
            'nome_completo', v_nome_formatado,
            'email', v_reg.email,
            'tipo_perfil', 'Família',
            'serial_utilizado', v_reg.serial_utilizado,
            'tabela_origem', 'assinaturas_b2c'
        );
    END IF;

    -- 4. REJEIÇÃO TOTAL
    RETURN json_build_object(
        'valido', false,
        'serial_utilizado', false,
        'mensagem', 'Serial de ativação inválido ou inexistente.'
    );
END;$$;

CREATE OR REPLACE FUNCTION "public"."fn_ativar_serial_e_criar_org"("p_serial_ativacao" "text", "p_user_id" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    v_serial_uuid uuid;
    v_user_uuid uuid;
    
    -- Dados de extração
    v_contrato_id uuid;
    v_nome_original text;
    v_documento text;
    v_whatsapp_compra text;
    v_plano_id integer;
    v_tipo_org text;
    v_tabela_origem text;
    v_nova_org_id uuid;
    
    -- Formatação
    v_nome_org text;
    v_nome_perfil text;
    v_arr_nome text[];
    
    -- Variáveis de Limites (CRs)
    v_limite_crs_atual integer;
    v_limite_crs_plano integer;
BEGIN
    -- 1. VALIDAÇÃO DE ENTRADA
    IF p_serial_ativacao IS NULL OR p_serial_ativacao = '' THEN
        RETURN json_build_object('sucesso', false, 'mensagem', 'Serial não informado pelo aplicativo.');
    END IF;

    IF p_user_id IS NULL OR p_user_id = '' THEN
        RETURN json_build_object('sucesso', false, 'mensagem', 'Usuário não autenticado ou sessão expirada.');
    END IF;

    -- 2. CONVERSÃO SEGURA PARA UUID
    BEGIN
        v_serial_uuid := p_serial_ativacao::uuid;
        v_user_uuid := p_user_id::uuid;
    EXCEPTION WHEN invalid_text_representation THEN
        RETURN json_build_object('sucesso', false, 'mensagem', 'O formato do serial ou do identificador de usuário é inválido.');
    END;

    -- 3. TENTA VINCULAR B2B (Empresas/Igrejas/ONGs/Indústrias)
    SELECT c.id, c.razao_social, c.cnpj, l.tipo_perfil, c.plano_id 
    INTO v_contrato_id, v_nome_original, v_documento, v_tipo_org, v_plano_id
    FROM public.contratos_b2b c
    LEFT JOIN public.leads_comercial l ON c.cnpj = l.documento_identificacao 
    WHERE c.serial_ativacao = v_serial_uuid AND (c.serial_utilizado = false OR c.serial_utilizado IS NULL);

    IF FOUND THEN
        v_tipo_org := COALESCE(v_tipo_org, 'Negócio');
        v_tabela_origem := 'contratos_b2b';
        v_nome_org := trim(v_nome_original);
        
        UPDATE public.contratos_b2b
        SET serial_utilizado = true, user_id = v_user_uuid
        WHERE id = v_contrato_id;
        
    ELSE
        -- 4. TENTA VINCULAR B2C (Famílias)
        SELECT nome_completo, cpf, whatsapp, plano_id 
        INTO v_nome_original, v_documento, v_whatsapp_compra, v_plano_id
        FROM public.assinaturas_b2c
        WHERE serial_ativacao = v_serial_uuid AND (serial_utilizado = false OR serial_utilizado IS NULL);

        IF FOUND THEN
            v_tipo_org := 'Família';
            v_tabela_origem := 'assinaturas_b2c';

            v_arr_nome := string_to_array(trim(COALESCE(v_nome_original, 'Família')), ' ');
            v_nome_org := 'Pessoal ' || v_arr_nome[1];
            
            IF array_length(v_arr_nome, 1) > 1 THEN
                v_nome_perfil := v_arr_nome[1] || ' ' || v_arr_nome[array_length(v_arr_nome, 1)];
            ELSE
                v_nome_perfil := v_arr_nome[1];
            END IF;

            UPDATE public.assinaturas_b2c
            SET serial_utilizado = true, user_id = v_user_uuid
            WHERE serial_ativacao = v_serial_uuid;
            
            UPDATE public.profiles
            SET 
                nome_completo = COALESCE(v_nome_perfil, profiles.nome_completo),
                whatsapp = COALESCE(v_whatsapp_compra, profiles.whatsapp)
            WHERE id = v_user_uuid;

        ELSE
            RETURN json_build_object('sucesso', false, 'mensagem', 'Serial inválido ou já utilizado.');
        END IF;
    END IF;

    -- 4.5. BUSCA O LIMITE DE CRs DO PLANO ANTES DE CRIAR A ORGANIZAÇÃO
    IF v_plano_id IS NOT NULL THEN
        SELECT limite_crs INTO v_limite_crs_plano -- Substitua 'limite_crs' se a coluna tiver outro nome na tabela planos_comerciais
        FROM public.planos_comerciais
        WHERE id = v_plano_id;
    END IF;

    -- Assume o limite do plano como o limite atual (Se for nulo, fallback para 3 CRs básicos)
    v_limite_crs_atual := COALESCE(v_limite_crs_plano, 3);

    -- 5. CRIA A ORGANIZAÇÃO E GRAVA O LIMITE
    INSERT INTO public.organizations (nome, tipo, documento_cnpj, plano_id, owner_id, limite_crs_atual)
    VALUES (
        COALESCE(v_nome_org, 'Organização'), 
        v_tipo_org, 
        v_documento, 
        v_plano_id, 
        v_user_uuid,
        v_limite_crs_atual  -- <== AGORA O DADO É GRAVADO FISICAMENTE NO BANCO
    )
    RETURNING id INTO v_nova_org_id;

    -- 6. AMARRAÇÃO DE CHAVES ESTRANGEIRAS
    IF v_tabela_origem = 'contratos_b2b' THEN
        UPDATE public.assinaturas_b2b
        SET organization_id = v_nova_org_id,
            plano_id = COALESCE(assinaturas_b2b.plano_id, v_plano_id)
        WHERE contrato_id = v_contrato_id;
        
    ELSIF v_tabela_origem = 'assinaturas_b2c' THEN
        UPDATE public.assinaturas_b2c
        SET organization_id = v_nova_org_id
        WHERE serial_ativacao = v_serial_uuid;
    END IF;

    -- 7. VINCULA O USUÁRIO COMO DONO DA ORGANIZAÇÃO
    INSERT INTO public.organization_members (organization_id, profile_id, funcao)
    VALUES (v_nova_org_id, v_user_uuid, 'Dono');

    -- 8. RETORNA O PACOTE DE SUCESSO
    RETURN json_build_object(
        'sucesso', true, 
        'currentOrganizationId', v_nova_org_id,
        'currentOrganizationType', v_tipo_org,
        'currentOrganizationName', v_nome_org,
        'currentUser', v_user_uuid,
        'currentFunction', 'Dono',
        'limite_crs_atual', v_limite_crs_atual,
        'limite_crs_plano', v_limite_crs_plano
    );
END;$$;

CREATE OR REPLACE FUNCTION "public"."fn_validar_cupom"("p_codigo" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_cupom record;
    v_usos integer;
BEGIN
    IF p_codigo IS NULL OR trim(p_codigo) = '' THEN
        RETURN json_build_object('status', 'nenhum');
    END IF;

    SELECT * INTO v_cupom FROM public.codigos_parceria WHERE codigo = p_codigo;

    IF NOT FOUND THEN
        RETURN json_build_object('status', 'invalido', 'codigo', p_codigo);
    END IF;

    IF v_cupom.ativo = false THEN
        RETURN json_build_object('status', 'inativo', 'codigo', p_codigo);
    END IF;

    IF v_cupom.data_validade IS NOT NULL AND v_cupom.data_validade < now() THEN
        RETURN json_build_object('status', 'expirado', 'codigo', p_codigo);
    END IF;

    IF v_cupom.limite_usos IS NOT NULL THEN
        SELECT count(*) INTO v_usos FROM public.contratos_b2b WHERE codigo_parceria = p_codigo;
        IF v_usos >= v_cupom.limite_usos THEN
            RETURN json_build_object('status', 'esgotado', 'codigo', p_codigo);
        END IF;
    END IF;

    -- Se passou por tudo, o cupom é válido! Retorna os dados da matemática.
    RETURN json_build_object(
        'status', 'valido',
        'codigo', p_codigo,
        'tipo_desconto', v_cupom.tipo_desconto,
        'percentual_desconto', v_cupom.percentual_desconto,
        'valor_desconto_fixo', v_cupom.valor_desconto_fixo,
        'aplica_em', v_cupom.aplica_em
    );
END;
$$;

CREATE OR REPLACE FUNCTION "public"."populate_organization_defaults"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$BEGIN
  -- =================================================================
  -- ⛪ CENÁRIO 1: IGREJA (Gestão Eclesiástica Profissional)
  -- =================================================================
  IF NEW.tipo = 'Igreja' THEN

    -- A. Contas Bancárias
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Cofre / Tesouraria (Dinheiro em Espécie)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Corrente Principal (Movimento)', 'CORRENTE', 0.00),
    (NEW.id, '03. Cartão de Crédito Corporativo', 'CARTAO', 0.00),
    (NEW.id, '04. Fundo de Obras e Construção (Poupança)', 'POUPANCA', 0.00),
    (NEW.id, '05. Fundo de Missões (Conta Específica)', 'CORRENTE', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '06. Investimentos e Aplicações (Reserva)', 'INVESTIMENTO', 0.00);

    -- B. Centros de Custo (Distribuição do Orçamento)
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral / Tesouraria', false, true, true, '#8E949D', 'Fundo Geral oficial da instituição, onde caem os dízimos não carimbados.'),
    (NEW.id, '01. Administração e Templo', true, false, true, '#D32F2F', 'Custos operacionais fixos, escritório, contas de consumo e gestão central.'),
    (NEW.id, '02. Eventos e Comunhão', false, false, true, '#C2185B', 'Festividades, retiros, recepções e momentos de confraternização da irmandade.'),
    (NEW.id, '03. Ministério de Missões e Evangelismo', false, false, true, '#7B1FA2', 'Ações de impacto, viagens missionárias, sustento de obreiros no campo.'),
    (NEW.id, '04. Ministério de Ensino (EBD)', false, false, true, '#512DA8', 'Funcionamento da Escola Bíblica, seminários de formação e materiais pedagógicos.'),
    (NEW.id, '05. Ministério Infantil e Juniores', false, false, true, '#303F9F', 'Atividades, lanches e recursos didáticos para o departamento de crianças.'),
    (NEW.id, '06. Ministério de Jovens e Adolescentes', false, false, true, '#1976D2', 'Ações, cultos e eventos voltados para a juventude (rede jovem).'),
    (NEW.id, '07. Ministério de Louvor e Mídia', false, false, true, '#0097A7', 'Equipamentos de som, instrumentos, equipe de transmissão e projeção.'),
    (NEW.id, '08. Ministério de Mulheres', false, false, true, '#00796B', 'Atividades e eventos realizados pelo departamento feminino.'),
    (NEW.id, '09. Ministério de Homens', false, false, true, '#388E3C', 'Atividades e eventos realizados pelo departamento masculino.'),
    (NEW.id, '10. Ministério de Ação Social', false, false, true, '#AFB42B', 'Cestas básicas e auxílio a famílias em vulnerabilidade dentro e fora da igreja.'),
    (NEW.id, '11. Manutenção Predial e Zeladoria', false, false, true, '#F57C00', 'Cuidados com o templo físico, climatização, limpeza, reformas e pequenos reparos.'),
    (NEW.id, '12. Terceiros e Adiantamentos', false, false, true, '#5D4037', 'Valores em trânsito, reembolsos ou pagamentos por conta de terceiros.');

    -- C. Plano de Contas Eclesiástico (CORRIGIDO E NORMALIZADO)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- 1.0 RECEITAS (SINTÉTICA)
    (NEW.id, '1.0 RECEITAS DA IGREJA', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Grupo principal de entradas e arrecadações.'),

    (NEW.id, '1.1 Entradas Operacionais', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Agrupador de dízimos e ofertas.'),
    (NEW.id, 'Dízimos', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Contribuições regulares e sistemáticas de membros (10%).'),
    (NEW.id, 'Ofertas de Culto Público (Alçadas)', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Valores voluntários entregues nos cultos sem destinação específica.'),
    (NEW.id, 'Ofertas Carimbadas para Missões', '1.1.03', 'RECEITA', 'ENTRADA', TRUE, 'Valores específicos exclusivos para o fundo de missões.'),
    (NEW.id, 'Ofertas para Construção e Reformas', '1.1.04', 'RECEITA', 'ENTRADA', TRUE, 'Arrecadações específicas para obras ou compra de imóveis.'),
    (NEW.id, 'Votos e Doações Específicas', '1.1.05', 'RECEITA', 'ENTRADA', TRUE, 'Ex: Doação de um irmão para comprar cadeiras ou um ar condicionado.'),
    (NEW.id, 'Venda de Cantina, Bazar e Livraria', '1.1.06', 'RECEITA', 'ENTRADA', TRUE, 'Receita bruta de vendas internas realizadas por ministérios.'),
    (NEW.id, 'Inscrições de Eventos e Retiros', '1.1.07', 'RECEITA', 'ENTRADA', TRUE, 'Taxas pagas por membros para participar de retiros, acampamentos ou jantares.'),
	(NEW.id, 'Outras Entradas Operacionais', '1.1.99', 'RECEITA', 'ENTRADA', TRUE, 'Receitas eventuais que não se enquadram nas categorias principais.'),	

    (NEW.id, '1.2 Receitas Não Operacionais', '1.2', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos financeiros ou extraordinários.'),
    (NEW.id, 'Rendimentos Financeiros', '1.2.01', 'RECEITA', 'ENTRADA', TRUE, 'Juros de aplicações, CDB, Poupança do Fundo de Construção.'),
    (NEW.id, 'Reembolsos e Devoluções', '1.2.02', 'RECEITA', 'ENTRADA', TRUE, 'Retorno de trocos ou acertos de adiantamentos feitos a líderes.'),
    (NEW.id, 'Venda de Bens/Ativos Usados', '1.2.03', 'RECEITA', 'ENTRADA', TRUE, 'Recebimento pela venda de um carro da igreja, instrumentos antigos, etc.'),
    (NEW.id, 'Outras Entradas Não Oper.', '1.2.99', 'RECEITA', 'ENTRADA', TRUE, 'Receitas eventuais que não se enquadram nas categorias principais.'),	

    -- 2.0 DESPESAS (SINTÉTICA)
    (NEW.id, '2.0 DESPESAS DA IGREJA', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Grupo principal de saídas operacionais.'),

    (NEW.id, '2.1 Sustento Pastoral e Pessoal', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Gastos com liderança, ministros e funcionários da igreja.'),
    (NEW.id, 'Prebenda Pastoral (Congrua)', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Sustento do ministro religioso (Não é salário, é provento eclesiástico).'),
    (NEW.id, 'Auxílio Moradia/Combustível Pastoral', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Ajuda de custo específica prevista em ata para o pastor.'),
    (NEW.id, 'Ofertas a Preletores/Cantores Convidados', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Honorários/Ofertas entregues a convidados externos.'),
    (NEW.id, 'Salários Funcionários (CLT)', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Folha de pagamento de secretária, zelador, etc.'),
    (NEW.id, 'Encargos e Impostos (INSS/FGTS/IRRF)', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Tributos sobre folha e INSS patronal/retido do pastor.'),
    (NEW.id, 'Benefícios (VT/VA)', '2.1.06', 'DESPESA', 'SAIDA', TRUE, 'Vale transporte e alimentação de funcionários CLT.'),

    (NEW.id, '2.2 Estrutura e Administração', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Gastos fixos para manter as portas da igreja abertas.'),
    (NEW.id, 'Aluguel do Imóvel/Templo', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Pagamento mensal de locação do espaço físico.'),
    (NEW.id, 'Energia Elétrica/Água/Gás', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Contas de concessionárias.'),
    (NEW.id, 'Internet/Telefonia/Streaming', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Planos de fibra ótica e comunicação da secretaria.'),
    (NEW.id, 'Manutenção Predial e Reparos', '2.2.04', 'DESPESA', 'SAIDA', TRUE, 'Consertos, troca de lâmpadas, limpeza de ar condicionado.'),
    (NEW.id, 'Segurança e Monitoramento', '2.2.05', 'DESPESA', 'SAIDA', TRUE, 'Empresa de alarme, câmeras e vigilância.'),
    (NEW.id, 'Limpeza e Higiene', '2.2.06', 'DESPESA', 'SAIDA', TRUE, 'Insumos de limpeza e pagamento de diárias de zeladoria.'),
    (NEW.id, 'Contabilidade, Cartório e Jurídico', '2.2.07', 'DESPESA', 'SAIDA', TRUE, 'Honorários contábeis, taxas de registro de atas e advogados.'),
    (NEW.id, 'Taxas Bancárias', '2.2.08', 'DESPESA', 'SAIDA', TRUE, 'Tarifas de conta, aluguel de maquininha de cartão e juros de boletos.'),
    (NEW.id, 'Taxas Associativas (Convenção/Ordem)', '2.2.09', 'DESPESA', 'SAIDA', TRUE, 'Contribuições mensais para a Convenção Estadual ou Nacional.'),
    (NEW.id, 'Direitos Autorais e Licenças (ECAD)', '2.2.10', 'DESPESA', 'SAIDA', TRUE, 'Recolhimento obrigatório por uso de obras musicais.'),
    (NEW.id, 'Materiais de Escritório', '2.2.11', 'DESPESA', 'SAIDA', TRUE, 'Compra de papelaria, insumos de impressão e organização de escritório.'),
    (NEW.id, 'Seguros (Imóvel/Veículos/Eventos)', '2.2.12', 'DESPESA', 'SAIDA', TRUE, 'Apólices de proteção de bens e responsabilidade civil.'),
    (NEW.id, 'Juros e Multas', '2.2.13', 'DESPESA', 'SAIDA', 'TRUE', 'Encargos e penalidades por atraso no pagamento de obrigações.'),
    (NEW.id, 'Adiantamentos/Pagamentos por Terceiros', '2.2.14', 'DESPESA', 'SAIDA', TRUE, 'Valores repassados a terceiros que serão reembolsados futuramente.'),
    (NEW.id, 'Taxas e Alvarás Governamentais', '2.2.15', 'DESPESA', 'SAIDA', TRUE, 'Renovação de licenças de funcionamento, bombeiros e taxas municipais.'),
    (NEW.id, 'Copa e Cozinha', '2.2.16', 'DESPESA', 'SAIDA', TRUE, 'Insumos como café, açúcar e materiais de limpeza voltados para a copa.'),
    (NEW.id, 'Combustível e Transporte', '2.2.17', 'DESPESA', 'SAIDA', TRUE, 'Deslocamento de veículos oficiais e ajuda de custo para transporte.'),
    (NEW.id, 'Fretes e Entregas', '2.2.18', 'DESPESA', 'SAIDA', TRUE, 'Custos com transportadoras, envios postais ou motoboys.'),

    (NEW.id, '2.3 Educação Cristã', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Investimento no ensino e Escola Bíblica.'),
    (NEW.id, 'Material Didático (Revistas EBD)', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Compra de revistas trimestrais, Bíblias e livros para alunos.'),
    (NEW.id, 'Treinamento de Líderes e Cursos', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Inscrição de líderes em seminários ou capacitações externas.'),

    (NEW.id, '2.4 Comunicação, Mídia e Som', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Tecnologia da igreja.'),
    (NEW.id, 'Softwares e Assinaturas Digitais', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Mensalidade do sistema de gestão, Holyrics, Canva, Zoom.'),
    (NEW.id, 'Equipamentos e Acessórios (Som/Vídeo)', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Cabos, pilhas, palhetas, pequenos reparos em instrumentos.'),
    (NEW.id, 'Gráfica, Banners e Impressos', '2.4.03', 'DESPESA', 'SAIDA', TRUE, 'Impressão de panfletos, faixas de eventos e informativos.'),

    (NEW.id, '2.5 Ação Social', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Ministério de benevolência voltado à comunidade local.'),
    (NEW.id, 'Cestas Básicas e Alimentos', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Compra de alimentos para doação a famílias carentes.'),
    (NEW.id, 'Ajuda Financeira a Membros', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de contas de luz, remédios ou auxílio funeral para irmãos necessitados.'),

    (NEW.id, '2.6 Liturgia e Eventos', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Custos com cultos, ceia, festividades e recepções.'),
    (NEW.id, 'Ceia do Senhor (Elementos)', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Pão, suco de uva e cálices descartáveis.'),
    (NEW.id, 'Decoração e Infraestrutura de Eventos', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Locação de tendas, cadeiras extras, flores e decoração para festas.'),
    (NEW.id, 'Alimentação de Eventos/Cantina', '2.6.03', 'DESPESA', 'SAIDA', TRUE, 'Compra de insumos para fazer almoços, jantares ou lanches de eventos.'),
    (NEW.id, 'Hospedagem e Passagens', '2.6.04', 'DESPESA', 'SAIDA', TRUE, 'Hotel, passagens aéreas ou rodoviárias para preletores visitantes.'),
	(NEW.id, 'Presentes e Homenagens', '2.6.05', 'DESPESA', 'SAIDA', TRUE, 'Itens adquiridos para presentear membros, voluntários ou datas comemorativas.'),
	
    -- GRUPO NOVO CORRIGIDO: MISSÕES (Obrigatório devido às receitas de missões)
    (NEW.id, '2.7 Missões e Evangelismo', '2.7', 'DESPESA', 'SAIDA', FALSE, 'Saídas exclusivas para avanço missionário.'),
    (NEW.id, 'Sustento Missionário (Campo)', '2.7.01', 'DESPESA', 'SAIDA', TRUE, 'Envio financeiro mensal para missionários apoiados pela igreja.'),
    (NEW.id, 'Agências Missionárias', '2.7.02', 'DESPESA', 'SAIDA', TRUE, 'Doações institucionais para bases missionárias.'),
    (NEW.id, 'Materiais de Evangelismo e Impacto', '2.7.03', 'DESPESA', 'SAIDA', TRUE, 'Compra de folhetos, Bíblias para doação e ações de rua.'),

    -- 3.0 ATIVOS (Patrimônio) - Raízes com Natureza NULL
    (NEW.id, '3.0 ATIVOS E IMOBILIZADO', '3.0', 'ATIVO', NULL, FALSE, 'Investimentos duráveis e aquisição de patrimônio da igreja.'),
    (NEW.id, '3.1 Aquisições Patrimoniais', '3.1', 'ATIVO', NULL, FALSE, 'Agrupador de bens tangíveis.'),
    (NEW.id, 'Aquisição de Imóveis (Templo/Terrenos)', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compra de imóveis. Diminui o caixa, mas aumenta o patrimônio.'),
    (NEW.id, 'Aquisição de Veículos (Frota da Igreja)', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Compra de ônibus, vans ou carros institucionais.'),
    (NEW.id, 'Instrumentos Musicais e Mesa de Som', '3.1.03', 'ATIVO', 'SAIDA', TRUE, 'Equipamentos duráveis e de alto valor (Ativo Imobilizado).'),
    (NEW.id, 'Móveis, Ar Condicionado e Instalações', '3.1.04', 'ATIVO', 'SAIDA', TRUE, 'Climatização pesada, bancos de madeira, púlpitos e telões de LED.'),

    -- 4.0 PASSIVOS (Dívidas) - Raízes com Natureza NULL
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Registro de obrigações financeiras de longo prazo e empréstimos.'),
    (NEW.id, '4.1 Empréstimos e Parcelamentos', '4.1', 'PASSIVO', NULL, FALSE, 'Agrupador de movimentação de dívidas.'),
    (NEW.id, 'Entrada de Dinheiro via Empréstimo', '4.1.01', 'PASSIVO', 'ENTRADA', TRUE, 'Gera entrada de caixa via crédito tomado no banco.'),
    (NEW.id, 'Amortização do Principal (Pagamento da Dívida)', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Redução da dívida pagando parcelas (Lançar os juros na conta 2.2.08).'),
    (NEW.id, 'Acordos e Dívidas Renegociadas', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de compromissos atrasados negociados a longo prazo.'),

    -- 5.0 PATRIMÔNIO LÍQUIDO E TRANSIÇÕES - Raízes com Natureza NULL
    (NEW.id, '5.0 PATRIMÔNIO SOCIAL', '5.0', 'PL', NULL, FALSE, 'Riqueza acumulada da organização religiosa.'),
    (NEW.id, '5.1 Fundo Institucional', '5.1', 'PL', NULL, FALSE, 'Agrupador de capital da igreja.'),
    (NEW.id, 'Fundo Patrimonial da Igreja', '5.1.01', 'PL', NULL, TRUE, 'Representa o valor do estatuto e fundação histórica.'),
    (NEW.id, 'Superávit / Reservas Acumuladas', '5.1.02', 'PL', NULL, TRUE, 'Sobras financeiras de anos anteriores.'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.03', 'PL', NULL, TRUE, 'Usado apenas para inserir o saldo das contas bancárias ao começar a usar o sistema.'),

    -- 9.9.99 Conta de trânsito (SISTEMA)
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível para transferir recursos e orçamentos entre Ministérios.');

  -- =================================================================
  -- 🏢 CENÁRIO 2: ONG / OSC (Organização da Sociedade Civil)
  -- =================================================================
  ELSIF NEW.tipo = 'OSC/ONG' THEN

    -- A. Contas Bancárias (Rastreabilidade e Compliance)
    -- Na OSC, é obrigatório separar o dinheiro público do dinheiro privado.
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Caixa Fixo / Tesouraria (Dinheiro em Espécie)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Corrente Principal (Recursos Livres/Próprios)', 'CORRENTE', 0.00),
    (NEW.id, '03. Conta Vinculada - Fomento Municipal/Estadual', 'CORRENTE', 0.00),
    (NEW.id, '04. Conta Vinculada - Emendas Parlamentares', 'CORRENTE', 0.00),
    (NEW.id, '05. Cartão de Crédito Corporativo', 'CARTAO', 0.00),
    (NEW.id, '06. Fundo de Reserva Institucional (Aplicações)', 'INVESTIMENTO', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00);

    -- B. Centros de Custo (Estrutura Analítica de Projetos - EAP)
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral / Matriz Institucional', false, true, true, '#8E949D', 'O caixa livre da OSC. Recebe doações sem restrição e financia a máquina administrativa.'),
    (NEW.id, '01. Gestão Executiva e Governança', true, false, true, '#D32F2F', 'Custeio da diretoria, honorários contábeis/jurídicos e obrigações estatutárias.'),
    (NEW.id, '02. Captação de Recursos e Comunicação', false, false, true, '#C2185B', 'Equipe de telemarketing, marketing social, campanhas e elaboração de projetos.'),
    (NEW.id, '03. Projeto: Assistência Social e Acolhimento', false, false, true, '#1976D2', 'Atendimento direto, distribuição de cestas, roupas e triagem de vulnerabilidade.'),
    (NEW.id, '04. Projeto: Educação e Capacitação', false, false, true, '#512DA8', 'Cursos de qualificação profissional, reforço escolar e inclusão digital.'),
    (NEW.id, '05. Projeto: Cultura e Esporte Comunitário', false, false, true, '#0097A7', 'Oficinas de música, teatro, escolinhas de futebol, judô e balé.'),
    (NEW.id, '06. Projeto: Saúde e Bem-Estar', false, false, true, '#388E3C', 'Terapias, atendimento psicológico, assistência nutricional e campanhas de prevenção.'),
    (NEW.id, '07. Geração de Renda: Bazar e Brechó', false, false, true, '#F57C00', 'Estrutura de venda de itens doados para gerar recursos próprios (livres).'),
    (NEW.id, '08. Geração de Renda: Cantina e Oficinas', false, false, true, '#AFB42B', 'Venda de produtos fabricados na OSC (padaria comunitária, artesanato).'),
    (NEW.id, '09. Manutenção Predial e Frota', false, false, true, '#5D4037', 'Custo com a sede física, contas de consumo, limpeza e manutenção das vans/kombis.'),
    (NEW.id, '10. Voluntariado e Ação Comunitária', false, false, true, '#7B1FA2', 'Gestão, treinamento e ressarcimento de ajudas de custo para a rede de voluntários.'),
    (NEW.id, '11. Terceiros e Repasses em Trânsito', false, false, true, '#455A64', 'Valores pendentes de prestação de contas de oficineiros e educadores.');

    -- C. Plano de Contas OSC (Adequado ao MROSC e ITG 2002)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- 1.0 RECEITAS (SINTÉTICA)
    (NEW.id, '1.0 RECEITAS E ARRECADAÇÕES', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Grupo principal de entradas da organização.'),

    (NEW.id, '1.1 Receitas com Restrição (Recursos Carimbados)', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Verbas que exigem prestação de contas rigorosa da finalidade.'),
    (NEW.id, 'Subvenções e Fomentos Municipais', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Repasses da prefeitura (Termo de Fomento ou Colaboração).'),
    (NEW.id, 'Subvenções e Fomentos Estaduais/Federais', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Repasses do Estado ou União para execução de projetos.'),
    (NEW.id, 'Emendas Parlamentares', '1.1.03', 'RECEITA', 'ENTRADA', TRUE, 'Recursos direcionados por deputados ou vereadores.'),
    (NEW.id, 'Fundos de Direitos (FIA, Fundo do Idoso)', '1.1.04', 'RECEITA', 'ENTRADA', TRUE, 'Captação via renúncia fiscal do Imposto de Renda.'),
    (NEW.id, 'Patrocínio de Empresas (Projetos Específicos)', '1.1.05', 'RECEITA', 'ENTRADA', TRUE, 'Empresas que doam para uma oficina ou evento específico.'),

    (NEW.id, '1.2 Receitas sem Restrição (Recursos Livres)', '1.2', 'RECEITA', 'ENTRADA', FALSE, 'Geração de caixa próprio da OSC (Fundo Geral).'),
    (NEW.id, 'Doações de Pessoas Físicas (Doadores/Padrinhos)', '1.2.01', 'RECEITA', 'ENTRADA', TRUE, 'Contribuições mensais via carnê, PIX ou cartão de crédito.'),
    (NEW.id, 'Doações de Pessoas Jurídicas (Livres)', '1.2.02', 'RECEITA', 'ENTRADA', TRUE, 'Empresas que apoiam a causa sem exigir vinculação a um projeto.'),
    (NEW.id, 'Arrecadação de Campanhas e Telemarketing', '1.2.03', 'RECEITA', 'ENTRADA', TRUE, 'Doações geradas por ligações ativas ou campanhas de rua.'),
    (NEW.id, 'Eventos Beneficentes (Jantares, Feijoadas)', '1.2.04', 'RECEITA', 'ENTRADA', TRUE, 'Venda de convites e arrecadações em eventos de gala ou populares.'),
    (NEW.id, 'Venda de Produtos (Bazar, Brechó, Artesanato)', '1.2.05', 'RECEITA', 'ENTRADA', TRUE, 'Receita bruta gerada pelas frentes de economia solidária da OSC.'),
    (NEW.id, 'Prestação de Serviços (Cursos/Palestras)', '1.2.06', 'RECEITA', 'ENTRADA', TRUE, 'Recebimento por capacitações ou consultorias oferecidas pela OSC.'),

    (NEW.id, '1.3 Receitas Financeiras e Extraordinárias', '1.3', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos passivos de capital.'),
    (NEW.id, 'Rendimentos de Aplicações e Poupança', '1.3.01', 'RECEITA', 'ENTRADA', TRUE, 'Juros sobre os saldos mantidos nas contas bancárias.'),
    (NEW.id, 'Recuperação de Despesas / Reembolsos', '1.3.02', 'RECEITA', 'ENTRADA', TRUE, 'Devolução de valores adiantados que não foram utilizados.'),
    (NEW.id, 'Venda de Ativos Imobilizados (Sucata/Veículos)', '1.3.03', 'RECEITA', 'ENTRADA', TRUE, 'Entrada de caixa pela venda de bens obsoletos da instituição.'),

    -- 2.0 DESPESAS E CUSTOS (SINTÉTICA)
    (NEW.id, '2.0 DESPESAS E CUSTOS SOCIAIS', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Grupo principal de desembolsos da organização.'),

    (NEW.id, '2.1 Pessoal e Encargos (RH Técnico e Administrativo)', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Custeio da equipe contratada.'),
    (NEW.id, 'Salários e Ordenados (CLT)', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Folha de pagamento de assistentes sociais, psicólogos, coordenadores.'),
    (NEW.id, 'Encargos Trabalhistas (INSS/FGTS/PIS)', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Tributos sobre a folha (observar isenções de CEBAS, se houver).'),
    (NEW.id, 'Benefícios (Vale Transporte/Alimentação)', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Benefícios legais pagos aos funcionários.'),
    (NEW.id, 'Serviços de Terceiros e Autônomos (RPA/PJ)', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Honorários de oficineiros, palestrantes e profissionais sem vínculo CLT.'),
    (NEW.id, 'Ajuda de Custo para Voluntários (Lei 9.608/98)', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Ressarcimento legal de transporte e alimentação para voluntários.'),

    (NEW.id, '2.2 Custos Diretos dos Projetos Fim (Atividade-Fim)', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Despesas que chegam diretamente ao beneficiário da OSC.'),
    (NEW.id, 'Gêneros Alimentícios e Cestas Básicas', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Comida para doação ou preparo de lanches para as crianças/assistidos.'),
    (NEW.id, 'Material Pedagógico, Didático e Cultural', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Cadernos, livros, tintas, instrumentos musicais para as oficinas.'),
    (NEW.id, 'Medicamentos, Fraldas e Materiais de Saúde', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Insumos hospitalares, higiene pessoal e farmácia para doação.'),
    (NEW.id, 'Vestuário e Uniformes (Assistidos)', '2.2.04', 'DESPESA', 'SAIDA', TRUE, 'Compra de roupas, cobertores e uniformes para os projetos esportivos.'),
    (NEW.id, 'Transporte de Assistidos / Excursões', '2.2.05', 'DESPESA', 'SAIDA', TRUE, 'Fretamento de ônibus para levar crianças a museus ou torneios.'),

    (NEW.id, '2.3 Custos de Estrutura e Administração (Atividade-Meio)', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Gastos fixos para manter as portas abertas.'),
    (NEW.id, 'Aluguel do Prédio/Sede e Condomínio', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Pagamento mensal de locação.'),
    (NEW.id, 'Água, Luz e Gás', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Contas de concessionárias.'),
    (NEW.id, 'Internet, Telefonia e Hospedagem de Sites', '2.3.03', 'DESPESA', 'SAIDA', TRUE, 'Comunicação da sede e sistemas de gestão.'),
    (NEW.id, 'Contabilidade, Auditoria e Honorários Jurídicos', '2.3.04', 'DESPESA', 'SAIDA', TRUE, 'Custos essenciais para manter a OSC regularizada nos conselhos.'),
    (NEW.id, 'Manutenção Predial, Reformas e Reparos', '2.3.05', 'DESPESA', 'SAIDA', TRUE, 'Consertos hidráulicos, elétricos, pintura e climatização.'),
    (NEW.id, 'Material de Limpeza e Higiene (Sede)', '2.3.06', 'DESPESA', 'SAIDA', TRUE, 'Insumos para manter a salubridade da organização.'),
    (NEW.id, 'Material de Escritório, Papelaria e Correios', '2.3.07', 'DESPESA', 'SAIDA', TRUE, 'Impressões, toners, papel A4, envios de correspondência.'),
    (NEW.id, 'Combustível, Manutenção e Seguro de Veículos', '2.3.08', 'DESPESA', 'SAIDA', TRUE, 'Custo da frota própria (kombi, vans, carros de apoio).'),
    (NEW.id, 'Despesas de Captação e Marketing', '2.3.09', 'DESPESA', 'SAIDA', TRUE, 'Tráfego pago, impressão de banners, comissionamento de telemarketing.'),
    (NEW.id, 'Taxas Bancárias, Juros e Anuidades', '2.3.10', 'DESPESA', 'SAIDA', TRUE, 'Custo de manutenção de conta, tarifas de boletos e maquininhas.'),
    (NEW.id, 'Taxas de Cartório e Emolumentos', '2.3.11', 'DESPESA', 'SAIDA', TRUE, 'Despesas com registro de atas, estatutos e reconhecimento de firmas.'),
    (NEW.id, 'Multas, Juros e Penalidades (Tributos)', '2.3.12', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de juros e multas por atraso (Ex: DARF Receita Federal). Não usar verba pública para isto.'),

    -- 3.0 ATIVOS (Patrimônio) - Raízes com Natureza NULL
    (NEW.id, '3.0 ATIVOS E IMOBILIZADO', '3.0', 'ATIVO', NULL, FALSE, 'Investimentos duráveis e aquisição de patrimônio da organização.'),
    (NEW.id, '3.1 Aquisições Patrimoniais', '3.1', 'ATIVO', NULL, FALSE, 'Agrupador de bens tangíveis.'),
    (NEW.id, 'Aquisição de Imóveis (Sede Própria/Terrenos)', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compra de imóveis. Diminui o caixa, mas aumenta o patrimônio.'),
    (NEW.id, 'Aquisição de Veículos e Ambulâncias', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Compra de frota para uso institucional.'),
    (NEW.id, 'Máquinas, Equipamentos Industriais e Médicos', '3.1.03', 'ATIVO', 'SAIDA', TRUE, 'Ex: Fornos para padaria solidária, macas, equipamentos de ponta.'),
    (NEW.id, 'Móveis, Informática e Climatização', '3.1.04', 'ATIVO', 'SAIDA', TRUE, 'Computadores, mesas, cadeiras, projetores e ar-condicionado.'),

    -- 4.0 PASSIVOS (Dívidas) - Raízes com Natureza NULL
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Registro de obrigações financeiras de longo prazo e empréstimos.'),
    (NEW.id, '4.1 Empréstimos e Acordos Trabalhistas', '4.1', 'PASSIVO', NULL, FALSE, 'Agrupador de movimentação de dívidas.'),
    (NEW.id, 'Entrada de Dinheiro via Empréstimo', '4.1.01', 'PASSIVO', 'ENTRADA', TRUE, 'Gera entrada de caixa via crédito tomado no banco.'),
    (NEW.id, 'Amortização do Principal (Pagamento da Dívida)', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Redução da dívida pagando parcelas.'),
    (NEW.id, 'Pagamento de Acordos e Indenizações Judiciais', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de processos cíveis ou trabalhistas parcelados.'),

    -- 5.0 PATRIMÔNIO LÍQUIDO E TRANSIÇÕES - Raízes com Natureza NULL
    (NEW.id, '5.0 PATRIMÔNIO SOCIAL', '5.0', 'PL', NULL, FALSE, 'Riqueza acumulada da Organização da Sociedade Civil.'),
    (NEW.id, '5.1 Fundo Institucional e Reservas', '5.1', 'PL', NULL, FALSE, 'Agrupador de capital da OSC.'),
    (NEW.id, 'Patrimônio Social (Fundo Inicial)', '5.1.01', 'PL', NULL, TRUE, 'Representa o valor da dotação inicial no estatuto da instituição.'),
    (NEW.id, 'Superávit / Déficit Acumulado', '5.1.02', 'PL', NULL, TRUE, 'Sobras financeiras de anos anteriores (Legalmente não distribuíveis).'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.03', 'PL', NULL, TRUE, 'Usado apenas para inserir o saldo das contas bancárias ao começar a usar o sistema.'),

    -- 9.9.99 Conta de trânsito (SISTEMA) - A mais crítica do seu sistema Híbrido
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível. Usada pelo Fundo Geral para cobrir déficits dos projetos sociais (Ex: Mandar R$ 5k da Matriz para a Educação).');
       
  -- 🏠 CENÁRIO 3: PESSOAL (Família e Patrimônio)
  -- =================================================================
  ELSIF NEW.tipo = 'Família' THEN

    -- A. Contas Bancárias
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Carteira (Dinheiro Vivo)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Corrente Principal', 'CORRENTE', 0.00),
    (NEW.id, '03. Conta Conjunta/Secundária', 'CORRENTE', 0.00),
    (NEW.id, '04. Cartão de Crédito', 'CARTAO', 0.00),
    (NEW.id, '05. Vale Alimentação/Refeição', 'CORRENTE', 0.00),
    (NEW.id, '06. Reserva de Emergência (Liquidez Diária)', 'INVESTIMENTO', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '06. Investimentos (Corretora/Ações)', 'INVESTIMENTO', 0.00);

    -- B. Centros de Custo
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral', false, true, true, '#8E949D', 'Local destinado a guardar todos os recebimentos antes da distribuição.'),
    (NEW.id, '01. Manutenção da Casa', true, false, true, '#D32F2F', 'Gastos compartilhados da residência: supermercado, contas de consumo e suprimentos.'),
    (NEW.id, '02. Pessoal - Titular', false, false, true, '#C2185B', 'Gastos individuais e exclusivos do titular: vestuário, hobbies, cuidados e lazer pessoal.'),
    (NEW.id, '03. Pessoal - Cônjuge', false, false, true, '#7B1FA2', 'Gastos individuais e exclusivos do cônjuge: vestuário, hobbies, cuidados e lazer pessoal.'),
    (NEW.id, '04. Filhos e Dependentes', false, false, true, '#512DA8', 'Custos com educação, saúde, vestuário e lazer voltados especificamente para os filhos.'),
    (NEW.id, '05. Animais de Estimação (Pets)', false, false, true, '#303F9F', 'Saúde, alimentação e higiene dos animais da família (Veterinário, Ração, Banho).'),
    (NEW.id, '06. Gestão de Veículos', false, false, true, '#1976D2', 'Custos totais de manutenção, combustível, impostos e seguros da frota familiar.'),
    (NEW.id, '07. Patrimônio e Imóvel', false, false, true, '#0097A7', 'Investimentos na propriedade: reformas, impostos prediais, seguros e valorização do bem.'),
    (NEW.id, '08. Lazer e Estilo de Vida', false, false, true, '#00796B', 'Gastos com qualidade de vida: viagens, passeios em família, jantares fora e entretenimento.'),
    (NEW.id, '09. Terceiros e Empréstimos', false, false, true, '#388E3C', 'Dinheiro em trânsito: valores emprestados a outros ou pagamentos de dívidas de terceiros.');

    -- C. Plano de Contas Corrigido (Fiel ao JSON)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- GRUPO 1: RECEITAS
    (NEW.id, '1.0 RECEITAS FAMILIARES', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Grupo principal de todas as entradas financeiras da família.'),
    
    (NEW.id, '1.1 Renda Ativa', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos resultantes do esforço direto e tempo de trabalho.'),
    (NEW.id, 'Salário Líquido (Holerite)', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Valor líquido que entra na conta após descontos do holerite.'),
    (NEW.id, 'Adiantamento Salarial (Vale)', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Valores recebidos antecipadamente do salário mensal.'),
    (NEW.id, '13º Salário/Férias', '1.1.03', 'RECEITA', 'ENTRADA', TRUE, 'Recebimentos sazonais de férias e gratificação natalina.'),
    (NEW.id, 'Bônus PLR', '1.1.04', 'RECEITA', 'ENTRADA', TRUE, 'Participação nos lucros e premiações corporativas.'),
    (NEW.id, 'Pró-labore (Retirada)', '1.1.05', 'RECEITA', 'ENTRADA', TRUE, 'Remuneração fixa retirada pelos sócios ou titulares.'),
    
    (NEW.id, '1.2 Renda Passiva e Extra', '1.2', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos que não dependem diretamente de jornada de trabalho fixa.'),
    (NEW.id, 'Renda Extra/Freelance', '1.2.01', 'RECEITA', 'ENTRADA', TRUE, 'Trabalhos pontuais, consultorias e serviços extras.'),
    (NEW.id, 'Dividendos/Rendimentos', '1.2.02', 'RECEITA', 'ENTRADA', TRUE, 'Lucros de investimentos, ações, FIIs e juros de contas.'),
    (NEW.id, 'Reembolso de Terceiros (Cartão/Empréstimo)', '1.2.03', 'RECEITA', 'ENTRADA', TRUE, 'Retorno de valores emprestados ou gastos no seu cartão para outros.'),
    (NEW.id, 'Presentes em Dinheiro', '1.2.04', 'RECEITA', 'ENTRADA', TRUE, 'Doações, presentes de aniversário ou heranças pontuais.'),
    
    (NEW.id, '1.3 Outras Entradas', '1.3', 'RECEITA', 'ENTRADA', FALSE, 'Entradas diversas e desmobilização de ativos.'),
    (NEW.id, 'Venda de Bens Menores', '1.3.01', 'RECEITA', 'ENTRADA', TRUE, 'Venda de itens usados (OLX, eletrónicos antigos, móveis).'),

    -- GRUPO 2: DESPESAS
    (NEW.id, '2.0 DESPESAS FAMILIARES', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Agrupador geral de saídas da família.'),
    
    (NEW.id, '2.1 Habitação', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Custos de manutenção e permanência na residência.'),
    (NEW.id, 'Aluguel Habitacional', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Pagamento mensal de moradia.'),
    (NEW.id, 'Condomínio', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Taxas condominiais e rateios extras de moradia.'),
    (NEW.id, 'Energia/Água/Gás', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Contas mensais de utilidades básicas da residência.'),
    (NEW.id, 'Internet/TV/Celular', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Serviços de telecomunicação, fibra e planos de dados móveis.'),
    (NEW.id, 'IPTU/Seguro Residencial', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Impostos anuais e seguros para proteção do imóvel.'),
    (NEW.id, 'Manutenção e Reparos Casa', '2.1.06', 'DESPESA', 'SAIDA', TRUE, 'Pequenos consertos, manutenções e reparos na residência.'),
    (NEW.id, 'Serviços Domésticos (Diarista)', '2.1.07', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de diaristas, jardineiros ou passadeiras.'),
    (NEW.id, 'Suprimentos e Limpeza', '2.1.08', 'DESPESA', 'SAIDA', TRUE, 'Produtos de limpeza, higiene e utilidades domésticas (não alimentares).'),
    
    (NEW.id, '2.2 Alimentação', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Gastos com sustento e prazer gastronômico.'),
    (NEW.id, 'Supermercado e Feira', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Compras de mantimentos essenciais para alimentação da casa.'),
    (NEW.id, 'Padaria e Açougue', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Compras diárias ou semanais de pães, frios e carnes frescas.'),
    (NEW.id, 'Restaurantes e Delivery', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Refeições fora de casa, aplicativos de delivery e lanches.'),
    
    (NEW.id, '2.3 Saúde e Bem Estar', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Cuidados com a integridade física e mental.'),
    (NEW.id, 'Plano de Saúde/Odonto', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Mensalidades de convênios médicos e odontológicos.'),
    (NEW.id, 'Farmácia e Medicamentos', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Compras de remédios de uso contínuo ou itens de farmácia.'),
    (NEW.id, 'Estética/Salão/Barbearia', '2.3.03', 'DESPESA', 'SAIDA', TRUE, 'Cuidados pessoais, salão, cortes de cabelo e estética.'),
    (NEW.id, 'Academia e Esportes', '2.3.04', 'DESPESA', 'SAIDA', TRUE, 'Mensalidades de academias, natação ou práticas esportivas.'),
    (NEW.id, 'Medicos\Odontos\Psicólogo\Exames\Outros (Particular)', '2.3.05', 'DESPESA', 'SAIDA', TRUE, 'Consultas e procedimentos médicos particulares, não cobertos por plano.'),
    
    (NEW.id, '2.4 Transporte', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Custos de mobilidade urbana e viagens curtas.'),
    (NEW.id, 'Combustível', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Gasolina, etanol, diesel ou recarga elétrica para veículos.'),
    (NEW.id, 'Uber/Táxi/Transporte Público', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Custos com mobilidade urbana, táxi e aplicativos de transporte.'),
    (NEW.id, 'IPVA/Licenciamento/Seguro Auto', '2.4.03', 'DESPESA', 'SAIDA', TRUE, 'Impostos anuais obrigatórios e proteção veicular.'),
    (NEW.id, 'Manutenção Mecânica/Lava-jato', '2.4.04', 'DESPESA', 'SAIDA', TRUE, 'Revisões, oficina, troca de óleo, pneus e estética automotiva.'),
    (NEW.id, 'Multas e Infrações', '2.4.05', 'DESPESA', 'SAIDA', TRUE, 'Custos com penalidades de trânsito (inesperados).'),
    
    (NEW.id, '2.5 Estilo de Vida e Educação', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Investimento em conhecimento e qualidade de vida.'),
    (NEW.id, 'Mensalidade Escolar/Faculdade', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Educação formal regular, seja escola básica ou ensino superior.'),
    (NEW.id, 'Cursos e Material Escolar', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Livros didáticos, cursos livres, mentorias e papelaria estudantil.'),
    (NEW.id, 'Assinaturas Digitais (Netflix/Spotify)', '2.5.03', 'DESPESA', 'SAIDA', TRUE, 'Serviços de streaming (vídeo/música), armazenamento em nuvem e VPNs.'),
    (NEW.id, 'Viagens e Férias', '2.5.04', 'DESPESA', 'SAIDA', TRUE, 'Passagens, hospedagens, passeios e gastos turísticos de lazer.'),
    (NEW.id, 'Vestuário, Calçados e Acessórios', '2.5.05', 'DESPESA', 'SAIDA', TRUE, 'Aquisição de roupas, calçados e acessórios de uso pessoal.'),
    (NEW.id, 'Despesas com Pets (Veterinário/Ração)', '2.5.06', 'DESPESA', 'SAIDA', TRUE, 'Cuidados, ração, banho e tosa, e consultas veterinárias de pets.'),
    (NEW.id, 'Presentes e Comemorações', '2.5.07', 'DESPESA', 'SAIDA', TRUE, 'Compra de presentes para aniversários, casamentos e datas festivas.'),
    (NEW.id, 'Eletrônicos e Pequenos Gadgets', '2.5.08', 'DESPESA', 'SAIDA', TRUE, 'Mouses, teclados, carregadores e itens de tecnologia.'),
    (NEW.id, 'Compras para Terceiros (Empréstimo Cartão)', '2.5.09', 'DESPESA', 'SAIDA', TRUE, 'Compras no seu cartão ou adiantamentos que serão pagos por terceiros.'),
    (NEW.id, 'Outras Despesas Pessoais', '2.5.10', 'DESPESA', 'SAIDA', TRUE, 'Pequenos gastos que não se enquadram nas categorias principais.'),
    
    (NEW.id, '2.6 Obrigações e Finanças', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Compromissos éticos, civis e financeiros.'),
    (NEW.id, 'Dízimos', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Contribuições religiosas mensais.'),
    (NEW.id, 'Ofertas/Doações', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Apoio ministerial e doações de caridade.'),
    (NEW.id, 'Imposto de Renda (IRPF)', '2.6.03', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de DARF, ajuste anual de IR ou carnê-leão.'),
    (NEW.id, 'Taxas Bancárias e Anuidades', '2.6.04', 'DESPESA', 'SAIDA', TRUE, 'Manutenção de conta e anuidade de cartões.'),
    (NEW.id, 'Juros e Multas Financeiras', '2.6.05', 'DESPESA', 'SAIDA', TRUE, 'Apenas os JUROS de boletos, cheque especial ou dívidas.'),
    (NEW.id, 'Seguro de Vida/Previdência Privada', '2.6.06', 'DESPESA', 'SAIDA', TRUE, 'Proteção familiar e aportes para aposentadoria privada.'),

    -- GRUPO 3: ATIVOS
    (NEW.id, '3.0 ATIVOS (Patrimônio)', '3.0', 'ATIVO', NULL, FALSE, 'Aquisição de bens duráveis e investimentos.'),
    
    (NEW.id, '3.1 Aquisições Patrimoniais', '3.1', 'ATIVO', NULL, FALSE, 'Agrupador de bens tangíveis.'),
    (NEW.id, 'Aquisição de Imóvel', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compra de casa, lote ou apartamento. Impacta caixa, aumenta ativo.'),
    (NEW.id, 'Aquisição de Veículo', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Troca ou compra de carro/moto. Impacta caixa, mas aumenta ativo.'),
    (NEW.id, 'Eletrodomésticos e Móveis', '3.1.03', 'ATIVO', 'SAIDA', TRUE, 'Geladeira, Máquina de Lavar, Sofás (Bens duráveis).'),
    (NEW.id, 'Aportes em Investimentos', '3.1.04', 'ATIVO', 'SAIDA', TRUE, 'Envio de dinheiro para Corretora, Ações, FIIs ou CDB.'),

    -- GRUPO 4: PASSIVOS
    (NEW.id, '4.0 PASSIVOS (Dívidas)', '4.0', 'PASSIVO', NULL, FALSE, 'Controle de obrigações de longo prazo.'),
    
    (NEW.id, '4.1 Empréstimos e Parcelamentos', '4.1', 'PASSIVO', NULL, FALSE, 'Agrupador de movimentação de dívidas.'),
    (NEW.id, 'Entrada de Empréstimo', '4.1.01', 'PASSIVO', 'ENTRADA', TRUE, 'Entrada de dinheiro no caixa proveniente de crédito de terceiros.'),
    (NEW.id, 'Amortização de Principal (Financiamento/Empréstimo)', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento APENAS DO PRINCIPAL da dívida. Juros devem ir para a conta de Juros.'),
    (NEW.id, 'Pagamento de Fatura Atrasada / Acordo', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Quitação de obrigações de faturas de cartões rotativos passados.'),

    -- GRUPO 5: PATRIMÔNIO LÍQUIDO
    (NEW.id, '5.0 PATRIMÔNIO LÍQUIDO', '5.0', 'PL', NULL, FALSE, 'Representa a riqueza real da família (Ativos - Passivos).'),
    
    (NEW.id, '5.1 Fundo Institucional', '5.1', 'PL', NULL, FALSE, 'Agrupador de capital da igreja.'),
    (NEW.id, 'Patrimônio Líquido Familiar', '5.1.01', 'PL', NULL, TRUE, 'Valor líquido da riqueza acumulada pela família (Soma de Ativos - Passivos).'),
    (NEW.id, 'Ajustes de Avaliação Patrimonial', '5.1.02', 'PL', NULL, TRUE, 'Usado para ajustar a valorização ou depreciação de bens sem envolver saída de caixa.'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.03', 'PL', NULL, TRUE, 'Usado apenas para inserir o saldo das contas bancárias ao começar a usar o sistema.'),
    
    -- SISTEMA
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível. Usada exclusivamente pelo sistema para transferir orçamentos entre Centros de Resultado.');

  -- =================================================================
  -- 🏢 CENÁRIO 4: COMÉRCIO (Gestão Empresarial)
  -- =================================================================
  ELSIF NEW.tipo = 'Negócio' THEN

    -- A. Contas Bancárias (Ajustado conceitualmente)
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Caixa Operacional (PDV/Gaveta)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Banco PJ Principal', 'CORRENTE', 0.00),
    (NEW.id, '03. Banco PJ Secundário', 'CORRENTE', 0.00),
    (NEW.id, '04. Cartão de Crédito Corporativo', 'CARTAO', 0.00),
    (NEW.id, '05. Recebíveis Cartão/Gateways (A Receber)', 'CORRENTE', 0.00), 
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '06. Conta Investimento / Reserva PJ', 'INVESTIMENTO', 0.00);

    -- B. CENTROS DE CUSTO (Distribuição por Resultado)
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral', false, true, true, '#8E949D', 'Local destinado a guardar todos os recebimentos.'),
    (NEW.id, '01. Vendas e Expansão', false, false, true, '#D32F2F', 'Equipe comercial, tráfego pago e aquisição de clientes (Foco em Receita).'),
    (NEW.id, '02. Operações e Entrega', false, false, true, '#C2185B', 'Execução do serviço e suporte ao cliente (Foco em Retenção).'),
    (NEW.id, '03. Tecnologia e Inovação', false, false, true, '#7B1FA2', 'Desenvolvimento, AWS, licenças SaaS e infraestrutura digital.'),
    (NEW.id, '04. Back-office e Gestão', true, false, true, '#512DA8', 'Diretoria, financeiro, RH e infraestrutura da sede. (PADRÃO)'),
    (NEW.id, '05. Logística e Suprimentos', false, false, true, '#303F9F', 'Compras, gestão de estoque e fretes de saída.');

    -- C. Plano de Contas (ARQUITETURA SIMÉTRICA DE 3 NÍVEIS)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- 1.0 RECEITAS
    (NEW.id, '1.0 RECEITAS', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Raiz de entradas.'),
    
    (NEW.id, '1.1 Receita Bruta Operacional', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Faturamento total.'),
    (NEW.id, 'Venda de Produtos (Mercadorias)', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Entrada por vendas de estoque.'),
    (NEW.id, 'Prestação de Serviços', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Faturamento de contratos e mão de obra.'),
    
    (NEW.id, '1.2 Deduções da Receita', '1.2', 'RECEITA', 'SAIDA', FALSE, 'Impostos diretos e estornos.'),
    (NEW.id, 'Impostos S/ Vendas (DAS/ISS/ICMS)', '1.2.01', 'RECEITA', 'SAIDA', TRUE, 'Tributos incidentes direto na Nota Fiscal.'),
    (NEW.id, 'Devoluções e Estornos', '1.2.02', 'RECEITA', 'SAIDA', TRUE, 'Devolução de dinheiro por vendas canceladas.'),
    (NEW.id, 'Descontos Concedidos', '1.2.03', 'RECEITA', 'SAIDA', TRUE, 'Abatimentos financeiros dados aos clientes.'),

    (NEW.id, '1.3 Receitas Não Operacionais', '1.3', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos secundários.'),
    (NEW.id, 'Rendimentos Financeiros', '1.3.01', 'RECEITA', 'ENTRADA', TRUE, 'Juros e rendimentos de aplicações da empresa.'),

    -- 2.0 CUSTOS E DESPESAS (Nivelamento Simétrico)
    (NEW.id, '2.0 CUSTOS E DESPESAS', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Raiz de saídas.'),
    
    (NEW.id, '2.1 Custos Variáveis (CMV/CSV)', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Gastos atrelados diretamente ao volume de vendas.'),
    (NEW.id, 'Compra de Mercadoria p/ Revenda', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Custo de aquisição junto a fornecedores.'),
    (NEW.id, 'Insumos e Materiais Aplicados', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Materiais gastos na prestação do serviço.'),
    (NEW.id, 'Taxas de Cartão e Gateways', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Taxas retidas pela maquininha ou emissor de PIX.'),
    (NEW.id, 'Comissões de Vendas', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Variável pago à equipe comercial.'),
    (NEW.id, 'Fretes de Entrega (Saída)', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Custo logístico de enviar ao cliente.'),

    (NEW.id, '2.2 Despesas de Pessoal e Gestão', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Custos fixos com capital humano (OPEX).'),
    (NEW.id, 'Pró-labore dos Sócios', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Salário fixo retirado pelos donos.'),
    (NEW.id, 'Salários e Encargos (Admin)', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Folha e impostos (INSS/FGTS) da equipe.'),
    (NEW.id, 'Benefícios (VT/VR/Saúde)', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Auxílios, planos de saúde e vales aos colaboradores.'),

    (NEW.id, '2.3 Ocupação e Infraestrutura', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Manutenção do espaço físico da empresa.'),
    (NEW.id, 'Aluguel, Condomínio e IPTU', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Custo do imóvel comercial.'),
    (NEW.id, 'Energia, Água e Internet', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Utilidades de operação da sede.'),
    (NEW.id, 'Limpeza e Manutenção Predial', '2.3.03', 'DESPESA', 'SAIDA', TRUE, 'Insumos de limpeza e pequenos reparos.'),

    (NEW.id, '2.4 Tecnologia e Sistemas', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Ecossistema digital corporativo.'),
    (NEW.id, 'Softwares e Licenças (SaaS)', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Sistemas ERP, CRM, Assinaturas.'),
    (NEW.id, 'Servidores e Domínios', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Hospedagem, AWS, Google Workspace.'),

    (NEW.id, '2.5 Administrativo e Legal', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Burocracia e operação interna.'),
    (NEW.id, 'Contabilidade e Jurídico', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Honorários de contadores e advogados.'),
    (NEW.id, 'Taxas Municipais e Alvarás', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Renovação de licenças de funcionamento.'),
    (NEW.id, 'Material de Escritório/Copa', '2.5.03', 'DESPESA', 'SAIDA', TRUE, 'Insumos internos, papelaria, café.'),

    (NEW.id, '2.6 Marketing e Aquisição (CAC)', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Motor de crescimento e atração de clientes.'),
    (NEW.id, 'Tráfego Pago (Ads)', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Investimento em Google, Meta, TikTok Ads.'),
    (NEW.id, 'Viagens e Representação', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Deslocamentos comerciais, jantares e networking.'),

    (NEW.id, '2.7 Resultado Financeiro', '2.7', 'DESPESA', 'SAIDA', FALSE, 'Despesas e tarifas bancárias.'),
    (NEW.id, 'Juros e Multas Pagos', '2.7.01', 'DESPESA', 'SAIDA', TRUE, 'Penalidades por atrasos de boletos e impostos.'),
    (NEW.id, 'Taxas de Antecipação de Recebíveis', '2.7.02', 'DESPESA', 'SAIDA', TRUE, 'Custo financeiro de antecipar vendas do cartão.'),
    (NEW.id, 'Tarifas Bancárias (Manutenção/PIX)', '2.7.03', 'DESPESA', 'SAIDA', TRUE, 'Taxas de manutenção de conta e emissão de boletos.'),

    -- 3.0 ATIVOS (Nulo na raiz, Fluxo nas folhas)
    (NEW.id, '3.0 ATIVOS', '3.0', 'ATIVO', NULL, FALSE, 'Bens e direitos da empresa.'),
    
    (NEW.id, '3.1 Ativo Circulante', '3.1', 'ATIVO', NULL, FALSE, 'Bens de alta liquidez e direitos de curto prazo.'),
    (NEW.id, 'Estoque de Mercadorias', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compras de produtos destinados ao estoque.'),
    (NEW.id, 'Adiantamentos a Fornecedores', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Dinheiro pago antes da mercadoria/serviço ser entregue.'),

    (NEW.id, '3.2 Ativo Imobilizado', '3.2', 'ATIVO', NULL, FALSE, 'Bens duráveis e investimentos operacionais.'),
    (NEW.id, 'Equipamentos de TI', '3.2.01', 'ATIVO', 'SAIDA', TRUE, 'Aquisição de computadores, impressoras e hardware.'),
    (NEW.id, 'Móveis e Utensílios', '3.2.02', 'ATIVO', 'SAIDA', TRUE, 'Mobiliário da loja/escritório, ar condicionado.'),
    (NEW.id, 'Veículos Próprios', '3.2.03', 'ATIVO', 'SAIDA', TRUE, 'Compra de frota registrada no CNPJ da empresa.'),

    -- 4.0 PASSIVOS (Nulo na raiz, Fluxo nas folhas)
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Obrigações e dívidas contraídas.'),
    
    (NEW.id, '4.1 Passivo Circulante (Curto Prazo)', '4.1', 'PASSIVO', NULL, FALSE, 'Contas e impostos a pagar até 12 meses.'),
    (NEW.id, 'Fornecedores a Pagar', '4.1.01', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de faturas e boletos de compras a prazo.'),
    (NEW.id, 'Impostos a Recolher', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de tributos que haviam sido apurados.'),
    (NEW.id, 'Férias e 13º (Provisões pagas)', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Saída de caixa para acerto de encargos trabalhistas anuais.'),

    (NEW.id, '4.2 Exigível a Longo Prazo / Financiamentos', '4.2', 'PASSIVO', NULL, FALSE, 'Dívidas bancárias e obrigações acima de 12 meses.'),
    (NEW.id, 'Entrada de Empréstimos Bancários', '4.2.01', 'PASSIVO', 'ENTRADA', TRUE, 'Injeção de capital no caixa provindo de financiamentos.'),
    (NEW.id, 'Amortização de Principal (Pagamento da Dívida)', '4.2.02', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento da parcela do empréstimo (Juros lançar em 2.7.01).'),

    -- 5.0 PATRIMÔNIO LÍQUIDO (Totalmente Neutro na raiz)
    (NEW.id, '5.0 PATRIMÔNIO LÍQUIDO', '5.0', 'PL', NULL, FALSE, 'Riqueza dos sócios e capital da empresa.'),
    
    (NEW.id, '5.1 Capital e Reservas', '5.1', 'PL', NULL, FALSE, 'Resultados, aportes e distribuições.'),
    (NEW.id, 'Capital Social Integralizado (Aporte)', '5.1.01', 'PL', 'ENTRADA', TRUE, 'Injeção de dinheiro no caixa pelos sócios.'),
    (NEW.id, 'Reserva de Lucros (Retenção)', '5.1.02', 'PL', NULL, TRUE, 'Reconhecimento contábil de lucro retido (Sem efeito de caixa).'),
    (NEW.id, 'Distribuição de Lucros (Dividendos)', '5.1.03', 'PL', 'SAIDA', TRUE, 'Saque de lucros pagos aos sócios (Impacta o caixa).'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.04', 'PL', NULL, TRUE, 'Conta de ajuste para inserir saldos bancários no início do uso.'),

    -- SISTEMA
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível para transferir recursos.');

  -- =================================================================
  -- 🏭 CENÁRIO 5: INDÚSTRIA
  -- =================================================================
  ELSIF NEW.tipo = 'Indústria' THEN
  
    -- A. Contas Bancárias
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Caixa Fixo Almoxarifado / Fábrica', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Movimento Principal (Recebimentos)', 'CORRENTE', 0.00),
    (NEW.id, '03. Conta Pagamento (Folha e Fornecedores)', 'CORRENTE', 0.00),
    (NEW.id, '04. Cartão de Crédito Corporativo (Compras)', 'CARTAO', 0.00),
    (NEW.id, '05. Conta FINAME / BNDES / Fomento', 'CORRENTE', 0.00),
    (NEW.id, '06. Provisão Tributária e Encargos (Reserva)', 'INVESTIMENTO', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '07. Fundo de Depreciação e CAPEX (Maquinário)', 'INVESTIMENTO', 0.00);
    
    -- B. CENTROS DE CUSTO
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral', false, true, true, '#8E949D', 'Local destinado a guardar todos os recebimentos não rateados.'),
    (NEW.id, '01. Chão de Fábrica / Produção', false, false, true, '#D32F2F', 'Coração da indústria: Mão de obra direta e transformação.'),
    (NEW.id, '02. Logística e Frota Pesada', false, false, true, '#C2185B', 'Escoamento de produção, caminhões e transportadoras.'),
    (NEW.id, '03. Manutenção Industrial', false, false, true, '#7B1FA2', 'Engenharia de manutenção, preventivas e corretivas de maquinário.'),
    (NEW.id, '04. Engenharia e P&D', false, false, true, '#512DA8', 'Desenvolvimento de novos produtos, protótipos e laboratório.'),
    (NEW.id, '05. Comercial e Vendas B2B', false, false, true, '#303F9F', 'Representantes comerciais, feiras industriais e prospecção.'),
    (NEW.id, '06. Administrativo Fabril', true, false, true, '#1976D2', 'Diretoria, RH, Contabilidade e infraestrutura de escritório. (PADRÃO)');

    -- C. PLANO DE CONTAS (ACHATADO PARA 3 NÍVEIS EXATOS)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) VALUES

    -- 1.0 RECEITAS
    (NEW.id, '1.0 RECEITAS INDUSTRIAIS', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Raiz de faturamento.'),
    
    (NEW.id, '1.1 Receita Bruta Industrial', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Faturamento de bens produzidos.'),
    (NEW.id, 'Venda de Produção Própria', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Nota fiscal de saída de produtos acabados.'),
    (NEW.id, 'Venda de Sucatas e Subprodutos', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Receita com aparas, plástico moído, paletes velhos.'),
    
    (NEW.id, '1.2 Deduções e Impostos S/ Vendas', '1.2', 'RECEITA', 'SAIDA', FALSE, 'Tributação e cancelamentos.'),
    (NEW.id, 'Impostos Diretos (IPI/ICMS/PIS/COFINS)', '1.2.01', 'RECEITA', 'SAIDA', TRUE, 'Tributos faturados na nota de saída.'),
    (NEW.id, 'Devoluções de Produção', '1.2.02', 'RECEITA', 'SAIDA', TRUE, 'Lotes recusados pelo cliente ou estornos.'),

    -- 2.0 CUSTOS E DESPESAS (Reestruturado para Simetria)
    (NEW.id, '2.0 CUSTOS E DESPESAS', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Raiz de saídas operacionais e fabris.'),
    
    (NEW.id, '2.1 Matéria-Prima (MP)', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Insumos base da transformação.'),
    (NEW.id, 'Compra de Matéria-Prima Base', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Aquisição de aço, grãos, polímeros, químicos.'),
    (NEW.id, 'Embalagens Industriais', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Caixas de papelão, stretch, paletes de envio.'),

    (NEW.id, '2.2 Mão de Obra Direta (MOD)', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Custos diretos com a equipe fabril.'),
    (NEW.id, 'Salários e Encargos (Chão de Fábrica)', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Folha de operadores de linha e montadores.'),
    (NEW.id, 'Benefícios Fabris e EPIs', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Refeitório fabril, botas, luvas e segurança do trabalho.'),

    (NEW.id, '2.3 Custos Indiretos de Fabricação (CIF)', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Despesas para manter a fábrica rodando.'),
    (NEW.id, 'Energia Industrial e Gás', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Insumo elétrico de alta tensão e combustíveis para fornos.'),
    (NEW.id, 'Manutenção de Máquinas e Peças', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Serviços de tornearia, lubrificantes e rolamentos.'),

    (NEW.id, '2.4 Logística e Distribuição', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Despesas de entrega e escoamento.'),
    (NEW.id, 'Diesel, Arla e Manutenção de Frota', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Custos com caminhões próprios.'),
    (NEW.id, 'Fretes Terceirizados e Pedágios', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Pagamento a transportadoras terceiras e rotas.'),

    (NEW.id, '2.5 Despesas Administrativas (OPEX)', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Custo do escritório da fábrica e gestão.'),
    (NEW.id, 'Pró-labore da Diretoria', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Remuneração fixa dos sócios.'),
    (NEW.id, 'Salários e Encargos (Escritório)', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Folha do RH, Financeiro e Suprimentos.'),
    (NEW.id, 'Aluguel, Condomínio e Limpeza (Sede)', '2.5.03', 'DESPESA', 'SAIDA', TRUE, 'Ocupação do prédio administrativo.'),
    (NEW.id, 'Sistemas ERP e Licenças', '2.5.04', 'DESPESA', 'SAIDA', TRUE, 'Software de gestão fabril e engenharias (CAD/SIGMA).'),
    (NEW.id, 'Contabilidade, Jurídico e Alvarás', '2.5.05', 'DESPESA', 'SAIDA', TRUE, 'Honorários, taxas e renovação de licenças.'),

    (NEW.id, '2.6 Marketing e Vendas B2B', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Custo de aquisição comercial.'),
    (NEW.id, 'Comissões de Representantes', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Percentuais pagos por contratos fechados.'),
    (NEW.id, 'Feiras Industriais e Amostras', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Stands em feiras e envio de protótipos a clientes.'),

    (NEW.id, '2.7 Resultado Financeiro', '2.7', 'DESPESA', 'SAIDA', FALSE, 'Custo do capital financeiro.'),
    (NEW.id, 'Juros de Financiamentos Fabris', '2.7.01', 'DESPESA', 'SAIDA', TRUE, 'Apenas os JUROS pagos por maquinário financiado.'),
    (NEW.id, 'Variação Cambial Passiva', '2.7.02', 'DESPESA', 'SAIDA', TRUE, 'Prejuízo na importação de insumos pela alta do dólar.'),
    (NEW.id, 'Taxas Bancárias e Antecipações', '2.7.03', 'DESPESA', 'SAIDA', TRUE, 'Custo de antecipação, Pix PJ e manutenção de conta.'),

    -- 3.0 ATIVOS (Raízes Nulas)
    (NEW.id, '3.0 ATIVOS', '3.0', 'ATIVO', NULL, FALSE, 'Bens e estoques da indústria.'),
    
    (NEW.id, '3.1 Estoques (Circulante)', '3.1', 'ATIVO', NULL, FALSE, 'O giro material da indústria.'),
    (NEW.id, 'Estoque de Matéria-Prima (MP)', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Insumos guardados no almoxarifado.'),
    (NEW.id, 'Estoque de Produtos Acabados (PA)', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Valor de produtos prontos para faturamento.'),

    (NEW.id, '3.2 Ativo Imobilizado', '3.2', 'ATIVO', NULL, FALSE, 'O parque fabril (CAPEX).'),
    (NEW.id, 'Máquinas e Equipamentos Pesados', '3.2.01', 'ATIVO', 'SAIDA', TRUE, 'Tornos, injetoras, extrusoras, caldeiras.'),
    (NEW.id, 'Veículos e Empilhadeiras', '3.2.02', 'ATIVO', 'SAIDA', TRUE, 'Caminhões e maquinário de movimentação interna.'),

    -- 4.0 PASSIVOS (Raízes Nulas)
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Obrigações e dívidas assumidas.'),
    
    (NEW.id, '4.1 Passivo Circulante (Curto Prazo)', '4.1', 'PASSIVO', NULL, FALSE, 'Obrigações imediatas.'),
    (NEW.id, 'Fornecedores de Matéria-Prima', '4.1.01', 'PASSIVO', 'SAIDA', TRUE, 'Pgto de insumos para a fábrica (Gera saída).'),
    (NEW.id, 'Impostos Industriais a Recolher', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'IPI/ICMS apurado (Gera saída no pagamento).'),

    (NEW.id, '4.2 Exigível a Longo Prazo e Financiamentos', '4.2', 'PASSIVO', NULL, FALSE, 'Dívidas estruturais.'),
    (NEW.id, 'Entrada de Financiamentos (BNDES/FINAME)', '4.2.01', 'PASSIVO', 'ENTRADA', TRUE, 'Entrada de crédito subsidiado para compra de imobilizado no caixa.'),
    (NEW.id, 'Amortização do Principal (Pagamento FINAME)', '4.2.02', 'PASSIVO', 'SAIDA', TRUE, 'Redução da dívida do maquinário através das parcelas pagas.'),

    -- 5.0 PATRIMÔNIO LÍQUIDO (Raízes e Reservas Nulas)
    (NEW.id, '5.0 PATRIMÔNIO LÍQUIDO', '5.0', 'PL', NULL, FALSE, 'Capital próprio e reinvestimento.'),
    
    (NEW.id, '5.1 Capital e Reservas', '5.1', 'PL', NULL, FALSE, 'Valor estrutural do negócio.'),
    (NEW.id, 'Capital Social Integralizado', '5.1.01', 'PL', 'ENTRADA', TRUE, 'Dinheiro investido inicialmente pelos donos.'),
    (NEW.id, 'Reserva para Ampliação Fabril', '5.1.02', 'PL', NULL, TRUE, 'Lucro retido para comprar novas máquinas (Registro sem efeito de caixa).'),
    (NEW.id, 'Distribuição de Lucros', '5.1.03', 'PL', 'SAIDA', TRUE, 'Lucro enviado aos sócios no exercício.'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.04', 'PL', NULL, TRUE, 'Conta de ajuste para inserir saldos bancários no início do uso.'),
    
    -- SISTEMA
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível para transferir orçamentos.');
  END IF;
  
  RETURN NEW;
END;$_$;


ALTER FUNCTION "public"."populate_organization_defaults"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION "public"."obter_saldo_total_org"("p_org_id" "uuid") RETURNS TABLE("total_saldo_inicial" numeric, "total_entradas_geral" numeric, "total_saidas_geral" numeric, "saldo_liquido_geral" numeric, "saldo_disponivel_real" numeric, "total_faturas_cartao" numeric, "total_a_receber" numeric, "total_a_pagar" numeric, "resumo_ativo_passivo" numeric, "total_ativos" numeric, "total_passivos" numeric, "saldo_bloqueado" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    WITH caixa_realizado AS (
        SELECT 
            COALESCE(SUM(v.saldo_inicial), 0)::numeric AS c_saldo_inicial,
            COALESCE(SUM(v.total_entradas), 0)::numeric AS c_entradas_geral,
            COALESCE(SUM(v.total_saidas), 0)::numeric AS c_saidas_geral,
            (COALESCE(SUM(v.total_entradas), 0) - COALESCE(SUM(v.total_saidas), 0))::numeric AS c_liquido_geral,
            
            -- O Disponível Real Só pega dinheiro solto.
            COALESCE(SUM(CASE WHEN v.tipo_conta NOT IN ('CARTAO', 'CARTÃO', 'VIRTUAL', 'APLICACAO', 'APLICAÇÃO', 'POUPANCA', 'POUPANÇA', 'INVESTIMENTO', 'FUNDO_DE_RESERVA', 'CAPITAL') THEN v.saldo_atual ELSE 0 END), 0)::numeric AS c_disponivel_real,
            
            -- O que está parado/investido
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('APLICACAO', 'APLICAÇÃO', 'POUPANCA', 'POUPANÇA', 'INVESTIMENTO', 'FUNDO_DE_RESERVA', 'CAPITAL') THEN v.saldo_atual ELSE 0 END), 0)::numeric AS c_reservas,

            -- Faturas de Cartão 
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('CARTAO', 'CARTÃO') THEN (v.saldo_atual * -1) ELSE 0 END), 0)::numeric AS c_faturas_cartao
            
        FROM public.obter_saldos_contas(p_org_id) v
    ),
    previsao_futura AS (
        SELECT
            COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric AS a_receber,
            COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric AS a_pagar
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
        LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
          AND t.status = 'PENDENTE'
          AND pc.codigo_contabil IS DISTINCT FROM '9.9.99'
          AND (cb.tipo IS DISTINCT FROM 'CARTAO' AND cb.tipo IS DISTINCT FROM 'CARTÃO')
    )
    SELECT 
        c.c_saldo_inicial AS total_saldo_inicial,
        c.c_entradas_geral AS total_entradas_geral,
        c.c_saidas_geral AS total_saidas_geral,
        c.c_liquido_geral AS saldo_liquido_geral,
        c.c_disponivel_real AS saldo_disponivel_real,
        c.c_faturas_cartao AS total_faturas_cartao,
        p.a_receber AS total_a_receber,
        p.a_pagar AS total_a_pagar,
        
        -- Métrica Original
        ((c.c_disponivel_real + c.c_reservas + p.a_receber) - (c.c_faturas_cartao + p.a_pagar))::numeric AS resumo_ativo_passivo,
        
        -- Novas métricas desmembradas para o FlutterFlow não esconder a matemática
        (c.c_disponivel_real + c.c_reservas + p.a_receber)::numeric AS total_ativos,
        (c.c_faturas_cartao + p.a_pagar)::numeric AS total_passivos,
        c.c_reservas AS saldo_bloqueado
        
    FROM caixa_realizado c CROSS JOIN previsao_futura p;
END;
$$;

CREATE OR REPLACE FUNCTION "public"."fn_resumo_saude_cr"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("qtd_verde" integer, "qtd_amarelo" integer, "qtd_vermelho" integer, "top_ofensores" "jsonb")
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_inicio_ano_contabil date;
    v_top_ofensores jsonb;
BEGIN
    v_inicio_ano_contabil := DATE_TRUNC('year', p_data_inicio)::date;

    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'nome', nome_cr,
            'saldo', saldo_periodo
        )
    ), '[]'::jsonb) INTO v_top_ofensores
    FROM (
        SELECT cc.nome AS nome_cr, 
               COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE 0 END), 0) -
               COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('DEBITO', 'DÉBITO') THEN t.valor ELSE 0 END), 0) AS saldo_periodo
        FROM public.centros_custo cc
        INNER JOIN public.transacoes t ON t.centro_custo_id = cc.id
        WHERE cc.organization_id = p_org_id 
          AND cc.ativo = true
          AND t.status = 'CONCILIADO'
          AND t.data_pagamento < ((p_data_fim + INTERVAL '1 day') AT TIME ZONE 'America/Sao_Paulo')
          AND (
              (cc.permite_acumulo = false AND t.data_pagamento >= (p_data_inicio AT TIME ZONE 'America/Sao_Paulo'))
              OR 
              (cc.permite_acumulo = true AND t.data_pagamento >= (v_inicio_ano_contabil AT TIME ZONE 'America/Sao_Paulo'))
          )
        GROUP BY cc.id, cc.nome
        HAVING (COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE 0 END), 0) - COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('DEBITO', 'DÉBITO') THEN t.valor ELSE 0 END), 0)) < 0
        ORDER BY saldo_periodo ASC
        LIMIT 3
    ) sub;

    RETURN QUERY
    WITH SaldosCR AS (
        SELECT 
            cc.id,
            COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('DEBITO', 'DÉBITO') THEN t.valor ELSE 0 END), 0) AS saldo_periodo
        FROM public.centros_custo cc
        LEFT JOIN public.transacoes t ON t.centro_custo_id = cc.id
          AND t.status = 'CONCILIADO'
          AND t.data_pagamento < ((p_data_fim + INTERVAL '1 day') AT TIME ZONE 'America/Sao_Paulo')
          AND (
              (cc.permite_acumulo = false AND t.data_pagamento >= (p_data_inicio AT TIME ZONE 'America/Sao_Paulo'))
              OR 
              (cc.permite_acumulo = true AND t.data_pagamento >= (v_inicio_ano_contabil AT TIME ZONE 'America/Sao_Paulo'))
          )
        WHERE cc.organization_id = p_org_id AND cc.ativo = true
        GROUP BY cc.id
    )
    SELECT 
        COUNT(CASE WHEN saldo_periodo > 0 THEN 1 END)::integer AS qtd_verde,
        COUNT(CASE WHEN saldo_periodo = 0 THEN 1 END)::integer AS qtd_amarelo,
        COUNT(CASE WHEN saldo_periodo < 0 THEN 1 END)::integer AS qtd_vermelho,
        v_top_ofensores AS top_ofensores
    FROM SaldosCR;
END;
$$;

-- 4. FUNÇÕES COM MUDANÇA DE TIPO DE RETORNO (DROP + RECREATE SEGURO)
DROP FUNCTION IF EXISTS public.fn_resumo_contas_pagar_receber(uuid);
CREATE OR REPLACE FUNCTION "public"."fn_resumo_contas_pagar_receber"("p_org_id" "uuid") RETURNS TABLE("total_pagar" numeric, "total_pagar_atrasado" numeric, "total_pagar_hoje" numeric, "total_pagar_vencer" numeric, "total_pagar_vencer_curto_prazo" numeric, "total_pagar_vencer_longo_prazo" numeric, "total_receber" numeric, "total_receber_atrasado" numeric, "total_receber_hoje" numeric, "total_receber_vencer" numeric, "total_receber_vencer_curto_prazo" numeric, "total_receber_vencer_longo_prazo" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    SELECT 
        -- CONTAS A PAGAR
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric AS total_pagar,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date < CURRENT_DATE), 0)::numeric AS total_pagar_atrasado,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date = CURRENT_DATE), 0)::numeric AS total_pagar_hoje,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date > CURRENT_DATE), 0)::numeric AS total_pagar_vencer,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date > CURRENT_DATE AND data_vencimento::date <= (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_pagar_vencer_curto_prazo,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date > (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_pagar_vencer_longo_prazo,

        -- CONTAS A RECEBER
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric AS total_receber,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date < CURRENT_DATE), 0)::numeric AS total_receber_atrasado,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date = CURRENT_DATE), 0)::numeric AS total_receber_hoje,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date > CURRENT_DATE), 0)::numeric AS total_receber_vencer,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date > CURRENT_DATE AND data_vencimento::date <= (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_receber_vencer_curto_prazo,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date > (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_receber_vencer_longo_prazo

    FROM public.transacoes
    WHERE organization_id = p_org_id
      AND status = 'PENDENTE'
      AND data_vencimento IS NOT NULL;
END;
$$;

DROP FUNCTION IF EXISTS public.upsert_lead_comercial(text, text, text, text, text, text);
CREATE OR REPLACE FUNCTION "public"."upsert_lead_comercial"(
    "p_documento" "text" DEFAULT NULL::"text", 
    "p_nome" "text" DEFAULT NULL::"text", 
    "p_instituicao" "text" DEFAULT 'Não informada'::"text", 
    "p_whatsapp" "text" DEFAULT NULL::"text", 
    "p_email" "text" DEFAULT NULL::"text", 
    "p_tipo_perfil" "text" DEFAULT NULL::"text"
) RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_lead_id uuid;
BEGIN
    INSERT INTO public.leads_comercial (
        documento_identificacao, 
        nome, 
        instituicao, 
        whatsapp, 
        email, 
        tipo_perfil, 
        quantidade_conversoes, 
        status
    )
    VALUES (
        p_documento, 
        p_nome, 
        p_instituicao, 
        p_whatsapp, 
        p_email, 
        p_tipo_perfil, 
        1, 
        'novo'
    )
    ON CONFLICT (documento_identificacao)
    DO UPDATE SET
        nome = COALESCE(EXCLUDED.nome, leads_comercial.nome),
        instituicao = COALESCE(EXCLUDED.instituicao, leads_comercial.instituicao),
        whatsapp = COALESCE(EXCLUDED.whatsapp, leads_comercial.whatsapp),
        email = COALESCE(EXCLUDED.email, leads_comercial.email),
        tipo_perfil = COALESCE(EXCLUDED.tipo_perfil, leads_comercial.tipo_perfil),
        ultima_interacao = timezone('utc', now()),
        quantidade_conversoes = leads_comercial.quantidade_conversoes + 1
        
    RETURNING id INTO v_lead_id;

    -- Constrói e devolve um JSON perfeito para o n8n
    RETURN json_build_object('id', v_lead_id);
END;
$$;

-- 5. PERMISSÕES DE ACESSO (GRANTS)
GRANT ALL ON FUNCTION public.fn_ativar_serial_e_criar_org(text, text) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.fn_validar_cupom(text) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.fn_resumo_contas_pagar_receber(uuid) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.upsert_lead_comercial(text, text, text, text, text, text) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.obter_saldo_total_org(uuid) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.fn_resumo_saude_cr(uuid, date, date) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.validar_serial(text) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.create_my_organization(text, text, uuid) TO anon, authenticated, service_role;
