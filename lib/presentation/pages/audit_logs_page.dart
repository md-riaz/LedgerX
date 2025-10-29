import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledgerx/data/repositories/audit_repository_impl.dart';
import 'package:ledgerx/domain/entities/audit_log.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AuditRepositoryImpl();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
      ),
      body: FutureBuilder<List<AuditLog>>(
        future: repository.getAllLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return const Center(
              child: Text('No audit logs found'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Statistics section
                FutureBuilder<Map<String, int>>(
                  future: repository.getActionStats(),
                  builder: (context, statsSnapshot) {
                    if (statsSnapshot.hasData) {
                      return _buildStatsSection(statsSnapshot.data!);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const Divider(),
                // Logs list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _buildLogItem(log);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(Map<String, int> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildChart(stats),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: stats.entries.map((entry) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: _getColorForAction(entry.key),
                  child: Text(
                    '${entry.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                label: Text(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(Map<String, int> stats) {
    final sections = stats.entries.map((entry) {
      final color = _getColorForAction(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: entry.key,
        color: color,
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
      ),
    );
  }

  Widget _buildLogItem(AuditLog log) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    final color = _getColorForAction(log.action);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            _getIconForAction(log.action),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          '${log.action} - ${log.entityType}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (log.details != null) Text(log.details!),
            Text(
              dateFormat.format(log.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: log.entityId != null
            ? Chip(
                label: Text(
                  'ID: ${log.entityId}',
                  style: const TextStyle(fontSize: 10),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            : null,
      ),
    );
  }

  Color _getColorForAction(String action) {
    switch (action.toUpperCase()) {
      case 'CREATE':
        return Colors.green;
      case 'UPDATE':
        return Colors.blue;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForAction(String action) {
    switch (action.toUpperCase()) {
      case 'CREATE':
        return Icons.add_circle;
      case 'UPDATE':
        return Icons.edit;
      case 'DELETE':
        return Icons.delete;
      default:
        return Icons.info;
    }
  }
}
