#ifndef TURTLEBROWSER_LICENSEMODEL_H
#define TURTLEBROWSER_LICENSEMODEL_H

#include <QtCore/QAbstractItemModel>
#include <QtCore/QDir>

#include <memory>

namespace turtle_browser::licenses {

  class LicenseItem;

  class LicenseModel : public QAbstractItemModel {

  public:
    LicenseModel(QString platformRootPath, QString qtRootPath, QString webviewRootPath, QObject * parentObject = nullptr);

    ~LicenseModel() override;

    QModelIndex index(int row, int column, const QModelIndex & parentIndex) const override;

    QModelIndex parent(const QModelIndex & childIndex) const override;

    int rowCount(const QModelIndex & parentIndex) const override;

    int columnCount(const QModelIndex & parentIndex) const override;

    QVariant data(const QModelIndex & index, int role) const override;

  private:
    void populate();

    QString m_platformRootPath;
    QString m_qtRootPath;
    QString m_webviewRootPath;
    QDir m_dir;
    std::unique_ptr<LicenseItem> m_rootItem;
  };

}

#endif //TURTLEBROWSER_LICENSEMODEL_H
