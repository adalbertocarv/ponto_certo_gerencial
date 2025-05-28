import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/widgets/centered_view/centered_view.dart';
import '../widgets/navigation_bar/navigation_bar.dart';
import '../home/home_page.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: CenteredView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com botão voltar
                  _buildHeader(context),
                  const SizedBox(height: 32),

                  // Conteúdo principal
                  _buildContent(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
            child: NavBarItem('Voltar'),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título principal responsivo
        _buildTitle(context, isDesktop, isTablet),
        const SizedBox(height: 32),

        // Descrição principal
        _buildMainDescription(),
        const SizedBox(height: 24),

        // Funcionalidades em grid responsivo
        _buildFunctionalitiesSection(context),
        const SizedBox(height: 40),

        // Seções de equipes em layout responsivo
        _buildTeamsSection(context),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, bool isDesktop, bool isTablet) {
    if (isDesktop) {
      return const Text(
        'SOBRE O APLICATIVO\nPONTO CERTO.',
        style: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.w800,
          height: 0.9,
          color: Colors.black87,
        ),
      );
    } else {
      return AutoSizeText(
        'SOBRE O APLICATIVO\nPONTO CERTO.',
        maxLines: 2,
        minFontSize: isTablet ? 40 : 28,
        style: TextStyle(
          fontSize: isTablet ? 60 : 50,
          fontWeight: FontWeight.w800,
          height: 0.9,
          color: Colors.black87,
        ),
      );
    }
  }

  Widget _buildMainDescription() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'O Ponto Certo é um aplicativo desenvolvido para auxiliar a Secretaria de Transporte '
        'e Mobilidade (SEMOB/SUTER) no mapeamento e cadastro de pontos de parada de ônibus no '
        'Distrito Federal. Esta ferramenta permite o registro detalhado de informações sobre '
        'cada ponto de parada, facilitando o planejamento e a manutenção do sistema de transporte público.',
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black87,
          height: 1.6,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildFunctionalitiesSection(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Principais Funcionalidades',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Grid responsivo de funcionalidades
        isMobile
            ? _buildFunctionalitiesList()
            : _buildFunctionalitiesGrid(context),
      ],
    );
  }

  Widget _buildFunctionalitiesList() {
    final functionalities = [
      {
        'icon': Icons.location_on,
        'title': 'Localização GPS',
        'desc': 'Coordenadas precisas da parada'
      },
      {
        'icon': Icons.add_road,
        'title': 'Identificação da Via',
        'desc': 'Via relacionada ao ponto'
      },
      {
        'icon': Icons.home,
        'title': 'Existência de Abrigo',
        'desc': 'Verificação de infraestrutura'
      },
      {
        'icon': Icons.accessible,
        'title': 'Acessibilidade',
        'desc': 'Condições de acesso'
      },
      {
        'icon': Icons.camera_alt,
        'title': 'Inserção de Imagens',
        'desc': 'Registro fotográfico'
      },
      {
        'icon': Icons.map,
        'title': 'Visualização em Mapa',
        'desc': 'Camadas de satélite'
      },
    ];

    return Column(
      children: functionalities
          .map(
            (func) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0069B4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      func['icon'] as IconData,
                      color: const Color(0xFF0069B4),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          func['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          func['desc'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFunctionalitiesGrid(BuildContext context) {
    final functionalities = [
      'Localização GPS da parada',
      'Identificação da via relacionada',
      'Existência de abrigo no ponto',
      'Condições de acessibilidade',
      'Inserção de imagens',
      'Visualização em mapa com camadas de satélite',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.isTablet ? 2 : 3,
          childAspectRatio: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 12,
        ),
        itemCount: functionalities.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0069B4).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF0069B4).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF0069B4),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    functionalities[index],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamsSection(BuildContext context) {
    final isMobile = context.isMobile;

    return isMobile ? _buildTeamsMobile() : _buildTeamsDesktop(context);
  }

  Widget _buildTeamsMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamCard(
          'Equipe Demandante/Organizacional',
          [
            'Ana Carolina Pereira de Araújo',
            'Gerson Antônio Silva Soares Ferreira'
          ],
          Icons.business,
        ),
        const SizedBox(height: 24),
        _buildTeamCard(
          'Equipe de Desenvolvimento',
          [
            'Adalberto Carvalho Santos Júnior',
            'Ednardo de Oliveira Ferreira',
            'Gabriel Pedro Veras',
            'Lucas Bezerra da Cruz',
          ],
          Icons.code,
        ),
      ],
    );
  }

  Widget _buildTeamsDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTeamCard(
            'Equipe Demandante/Organizacional',
            [
              'Ana Carolina Pereira de Araújo',
              'Gerson Antônio Silva Soares Ferreira'
            ],
            Icons.business,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildTeamCard(
            'Equipe de Desenvolvimento',
            [
              'Adalberto Carvalho Santos Júnior',
              'Ednardo de Oliveira Ferreira',
              'Gabriel Pedro Veras',
              'Lucas Bezerra da Cruz',
            ],
            Icons.code,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamCard(String title, List<String> members, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0069B4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0069B4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...members.map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      member,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
