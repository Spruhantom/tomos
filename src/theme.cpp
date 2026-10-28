#include "theme.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QProcess>
Theme::Theme(QObject *parent) : QObject(parent), m_path(QDir::homePath() + "/.local/state/omarchy/current") {
    m_debounce.setSingleShot(true);
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, [this] { m_debounce.start(80); });
    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, [this] { m_debounce.start(80); });
    connect(&m_debounce, &QTimer::timeout, this, &Theme::reload);
    reload();
    QTimer *rounding = new QTimer(this); rounding->setInterval(1200);
    connect(rounding, &QTimer::timeout, this, [this] {
        QProcess p; p.start("hyprctl", {"-j", "getoption", "decoration:rounding"});
        if (!p.waitForFinished(400)) return;
        auto m = QRegularExpression("\\\"int\\\"\\s*:\\s*(\\d+)").match(QString::fromUtf8(p.readAllStandardOutput()));
        if (m.hasMatch() && m.captured(1).toInt() != m_radius) { m_radius = m.captured(1).toInt(); emit changed(); }
    });
    rounding->start();
}
void Theme::reload() {
    const auto paths = m_watcher.files() + m_watcher.directories(); if (!paths.isEmpty()) m_watcher.removePaths(paths);
    QString ancestor = m_path;
    while (!QFileInfo::exists(ancestor) && ancestor != "/") ancestor = QFileInfo(ancestor).absolutePath();
    for (const auto &p : {ancestor, QFileInfo(ancestor).absolutePath(), m_path, m_path + "/theme", m_path + "/theme/colors.toml"})
        if (QFileInfo::exists(p)) m_watcher.addPath(p);
    QFile f(m_path + "/theme/colors.toml"); QString accent = "#FFD60A";
    if (f.open(QIODevice::ReadOnly)) {
        auto m = QRegularExpression("^\\s*accent\\s*=\\s*[\\\"'](#[0-9a-fA-F]{6})", QRegularExpression::MultilineOption).match(QString::fromUtf8(f.readAll()));
        if (m.hasMatch()) accent = m.captured(1);
    }
    if (accent != m_accent) { m_accent = accent; emit changed(); }
}
